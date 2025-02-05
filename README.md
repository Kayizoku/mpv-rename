# MPV-Rename

This script provides a powerful way to rename files directly within MPV, featuring single file renaming, batch renaming, and an advanced undo feature that lets you revert multiple renaming actions. Whether you're organizing media files or renaming large batches, this script allows you to manage your file names quickly, efficiently, and safely.

## Key Features:
- **Single File Renaming**: Quickly rename the current file with a custom name. A prompt will ask for a new filename, and the file will be renamed immediately.
- **Undo Rename**: The script supports multiple undo operations. You can press **U** to undo the last renaming operation and keep pressing it to continue undoing previous renames in reverse order. The rename history is stored, and each renaming action can be reverted step by step until you run out of history.
- **Batch Renaming**: Use patterns and replacements to rename multiple files at once. The script will apply the specified pattern and replacement to all matching files in the directory.
- **Rename History**: Keeps a stack of previously renamed files, enabling you to undo each renaming action individually. The history is persistent for each session until the script is reloaded or MPV is closed.
- **Log File**: Every renaming operation is logged in a `rename_log.txt` file, giving you a detailed record of all file renamings, including timestamps.

## Key Bindings:
- **F2**: Renames the current file. A prompt will appear for entering a new filename.
- **Shift+F2**: Triggers batch renaming. You can enter a pattern to match and a replacement text. The script will apply this to all matching files in the directory.
- **U**: Undoes the last renaming action. Press it multiple times to undo each previous renaming step in the order they were applied. The history of renamed files is maintained, so you can undo any recent rename, one by one, until all are reverted or the history is exhausted.

## How to Use:
1. **Install the Script**: Place the script in the `scripts` folder of your MPV configuration directory.
2. **Key Bindings**: The script comes with default key bindings:
   - **F2** to rename the current file.
   - **Shift+F2** to trigger batch renaming.
   - **U** to undo the last renaming action.
   You can customize these bindings within the script if desired.
3. **Batch Rename**: Press `Shift+F2` to start the batch renaming process. The script will ask for a pattern to match in the filenames and the replacement text. After confirming, you can apply the renaming to all matching files in the directory.
4. **Undo Renaming**: Press **U** to undo the most recent renaming. If you need to revert additional renames, continue pressing **U**, and the script will undo each rename operation in reverse order, allowing you to step back through the renaming history. You can keep pressing **U** until you reach the beginning of the history or until all renaming operations are undone.

## Requirements:
- **MPV** with Lua scripting enabled.
- **user-input-module** to handle interactive user prompts.

This script is perfect for users who frequently need to rename files in MPV, offering both flexibility and safety. Whether you're renaming a single file or performing batch operations, the undo functionality ensures that your files are renamed exactly how you want them—without the risk of mistakes.
