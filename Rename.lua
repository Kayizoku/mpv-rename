-- Author: Kayizoku - https://github.com/Kayizoku/mpv-rename/edit/main/Rename.lua
local mp = require "mp"
local msg = require "mp.msg"
local utils = require "mp.utils"

-- Variable to store the previous filename
local previousFilename = nil

package.path = mp.command_native({"expand-path", "~~/script-modules/?.lua;"})..package.path
local input = require "user-input-module"

local function rename(text, error)
    if not text then return msg.warn(error) end

    local filepath = mp.get_property("path")
    if filepath == nil then return end

    local directory, filename = utils.split_path(filepath)
    local name, extension = filename:match("(%a*)%.([^%./]+)$")
    if directory == "." then directory = "" end
    local newfilepath = directory..text

    -- Store the previous filename before renaming
    previousFilename = filename

    msg.info( string.format("renaming '%s.%s' to '%s'", name, extension, text) )
    local success, error = os.rename(filepath, newfilepath)
    if not success then 
        msg.error(error) 
        mp.osd_message("rename failed")
        return
    end

    -- adding the new path to the playlist, and restarting the file with the correct path
    mp.commandv("loadfile", newfilepath, "append")
    mp.commandv("playlist-move", mp.get_property_number("playlist-count", 2) - 1, mp.get_property_number("playlist-pos", 1) + 1)
    mp.commandv("playlist-remove", "current")
end

-- Function to undo the last rename operation
local function undoRename()
    if previousFilename then
        local filepath = mp.get_property("path")
        local directory, _ = utils.split_path(filepath)
        local previousFilepath = directory .. previousFilename

        local success, error = os.rename(filepath, previousFilepath)
        if success then
            msg.info("Undo rename successful")
            mp.osd_message("Undo rename successful")
            -- Update the playlist with the previous filepath
            mp.commandv("loadfile", previousFilepath, "append")
            mp.commandv("playlist-move", mp.get_property_number("playlist-count", 2) - 1, mp.get_property_number("playlist-pos", 1) + 1)
            mp.commandv("playlist-remove", "current")
            -- Clear the previous filename variable
            previousFilename = nil
        else
            msg.error("Failed to undo rename: " .. error)
            mp.osd_message("Failed to undo rename")
        end
    else
        msg.warn("No previous rename operation to undo")
        mp.osd_message("No previous rename operation to undo")
    end
end

-- Bind a key to the undoRename function
mp.add_key_binding("U", "undo-rename", undoRename)

-- Registering the event to cancel renaming if the file closes while renaming
mp.register_event("end-file", function()
    input.cancel_user_input()
end)

mp.add_key_binding("F2", "rename-file", function()
    filepath = mp.get_property('path')
    directory, filename = utils.split_path(filepath)
    input.cancel_user_input()
    input.get_user_input(rename, {
        text = "Enter new filename:",
        default_input = filename,
        replace = false,
        cursor_pos = filename:find("%.%w+$")
    })
    
end
)
