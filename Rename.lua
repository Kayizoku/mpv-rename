-- Author: Kayizoku 
local mp = require "mp"
local msg = require "mp.msg"
local utils = require "mp.utils"

-- Stack to store rename history
local renameHistory = {}

package.path = mp.command_native({"expand-path", "~~/script-modules/?.lua;"})..package.path
local input = require "user-input-module"

local function log_action(action)
    local logFile = "~~/rename_log.txt"
    local file = io.open(mp.command_native({"expand-path", logFile}), "a")
    if file then
        file:write(os.date("[%Y-%m-%d %H:%M:%S] ") .. action .. "\n")
        file:close()
    end
end

local function rename(text, error)
    if not text or text == "" then 
        msg.warn("Rename canceled")
        mp.osd_message("Rename canceled")
        return
    end

    local filepath = mp.get_property("path")
    if filepath == nil then return end

    local directory, filename = utils.split_path(filepath)
    local name, extension = filename:match("(.+)%.([^%./]+)$")
    if not name then name = filename end  -- Handle files with no extension
    if directory == "." then directory = "" end
    local newfilepath = directory .. text

    -- Prevent overwriting existing files
    if utils.file_info(newfilepath) then
        msg.error("File already exists! Choose a different name.")
        mp.osd_message("Rename failed: File exists")
        return
    end

    -- Store the filename in history before renaming
    table.insert(renameHistory, filename)

    msg.info(string.format("Renaming '%s.%s' to '%s'", name, extension or "", text))
    local success, error = os.rename(filepath, newfilepath)
    if not success then 
        msg.error("Rename failed: " .. error)
        mp.osd_message("Rename failed")
        return
    end

    log_action("Renamed: " .. filename .. " -> " .. text)
    mp.osd_message("Rename successful!", 3)

    -- Reload the renamed file in the playlist
    mp.commandv("loadfile", newfilepath, "append")
    mp.commandv("playlist-move", mp.get_property_number("playlist-count", 2) - 1, mp.get_property_number("playlist-pos", 1) + 1)
    mp.commandv("playlist-remove", "current")
end

local function undoRename()
    if #renameHistory == 0 then
        msg.warn("No previous rename operation to undo")
        mp.osd_message("No rename history")
        return
    end

    local filepath = mp.get_property("path")
    local directory, _ = utils.split_path(filepath)
    local previousFilename = table.remove(renameHistory)
    local previousFilepath = directory .. previousFilename

    local success, error = os.rename(filepath, previousFilepath)
    if success then
        log_action("Undo rename: " .. filepath .. " -> " .. previousFilename)
        msg.info("Undo rename successful")
        mp.osd_message("Undo rename successful", 3)
        -- Reload the previous filename
        mp.commandv("loadfile", previousFilepath, "append")
        mp.commandv("playlist-move", mp.get_property_number("playlist-count", 2) - 1, mp.get_property_number("playlist-pos", 1) + 1)
        mp.commandv("playlist-remove", "current")
    else
        msg.error("Failed to undo rename: " .. error)
        mp.osd_message("Failed to undo rename")
    end
end

function batch_rename(pattern, replace)
    local filepath = mp.get_property("path")
    if not filepath then return end

    local directory, filename = utils.split_path(filepath)
    local files = utils.readdir(directory) or {} -- Get all files in the directory

    local renamed_files = {}

    for _, file in ipairs(files) do
        if file:match(pattern) then
            local new_name = file:gsub(pattern, replace) -- Apply replacement
            local old_path = directory .. "/" .. file
            local new_path = directory .. "/" .. new_name

            if os.rename(old_path, new_path) then
                table.insert(renamed_files, {old = file, new = new_name})
                msg.info(string.format("Renamed: %s → %s", file, new_name))
            else
                msg.error("Failed to rename " .. file)
            end
        end
    end

    if #renamed_files > 0 then
        mp.osd_message(string.format("Renamed %d files", #renamed_files))
    else
        mp.osd_message("No matching files found")
    end
end

mp.add_key_binding("Shift+F2", "batch-rename", function()
    input.get_user_input(function(pattern)
        if not pattern or pattern == "" then return end
        input.get_user_input(function(replace)
            if not replace then return end
            input.get_user_input(function(confirm)
                if confirm:lower() == "y" then
                    batch_rename(pattern, replace)
                end
            end, { text = "Confirm rename? (Y to proceed):" })
        end, { text = "Enter replacement text:" })
    end, { text = "Enter pattern to match:" })
end)

-- Bind keys to functions
mp.add_key_binding("U", "undo-rename", undoRename)
mp.add_key_binding("F2", "rename-file", function()
    local filepath = mp.get_property("path")
    local directory, filename = utils.split_path(filepath)
    input.cancel_user_input()
    input.get_user_input(rename, {
        text = "Enter new filename:",
        default_input = filename,
        replace = false,
        cursor_pos = filename:find("%.%w+$")
    })
end)

-- Register event to cancel renaming on file close
mp.register_event("end-file", function()
    input.cancel_user_input()
end)
