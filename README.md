# mpv-rename

## Rename
This script makes it possible to rename files on the go directly within MPV player window without having to leave it for a second. 

## Installation
This script needs the [user-input-module](https://github.com/CogentRedTester/mpv-user-input/). Follow the appropriate steps.
Once thats's done, like any other script. Simply place `rename.lua` inside ~~/scripts/ directory. Create the folder if it dosen't exist. 


After you’ve added in mpv-user-input in the corresponding places. Simply place `rename.lua` inside `scripts` directory. Create the directory if it dosen’t exist. This script has only been tested for Windows, but should work on Linux.

## In-use
You can rename any files directly from MPV. The hotkey is set to `F2` on the current file in focus. Once that's pressed, a inputfield will show under the screen and the initial filename will be written out. You can edit the original name or remove it completely and rename it. Playlist will be reloaded as well and remove the original file to avoid duplication. To cancel an on-going rename request simply press `ESC` either while inputfield is empty or contains a value. Script retains all functionality of mpv-user-input. So  it remembers any changes and you can go throughy them by pressing `ARROW_KEY_UP` and look at the all the renaming that has been done.

## Hotkey
Don’t like the normal hot-key? No problem. If you put in `<key-binding> script-binding rename-file` in your `input.conf`. It will allow you to use your own custom keybind.

## Future Plans
As of now, I have nothing planned for the future. The script is already functioning well but you never know. There is always room for improvement. So feel free to fork it and improve on it with your ideas and imagination.
