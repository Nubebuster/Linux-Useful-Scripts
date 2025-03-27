# Linux Useful Scripts

Welcome to this collection of useful scripts for Linux users. Here, you'll find small but powerful tools designed to simplify common tasks and improve your workflow.

## Scripts

### fu Script

The **fu** script lets you easily interact with your clipboard and files. It provides two core commands:

- **paste [default_filename\*]:** Retrieves clipboard content and writes it to a file (prompts options to create, append, or overwrite).
- **clip [search_path\*]:** Uses an interactive file selector to choose a text file and copies its contents into the clipboard. If a file path is provided instead of a directory, its content is directly loaded into the clipboard.

\*Optional

Required packages (`xclip` and `fzf`) are automatically checked and, if missing, you will be prompted to install them.

## Installation and Setup

For any bash script in this repository:

1. **Move and the Scripts:**  
   
   Move the scripts (e.g., `fu.bash`) to your preferred directory as the command `fu`:
   ```bash
    # Create the directory ~/Scripts if it doesn't exist
    mkdir -p ~/Scripts && \
    # Move fu.bash to the ~/Scripts/fu directory
    mv fu.bash ~/Scripts/fu && \
    # Set executable permissions on the moved file
    chmod +x ~/Scripts/fu
   ```
   The filename that the file has in the Scripts directory is the command it ends up being. So you could so `mv fu.bash ~/Scripts/file-util` and then the command will be `file-util`.

2. **Source the Scripts:**  
   Add all scripts in the specified directory with execute permission to your bash configuration (in `~/.bashrc`):
   ```bash
    fgrep -qxF 'export PATH="$PATH:$HOME/Scripts"' ~/.bashrc || echo 'export PATH="$PATH:$HOME/Scripts"' >> ~/.bashrc
   ```

3. **Reload Your Shell:**  
   Restart your terminal or reload your bash configuration:
   ```bash
   source ~/.bashrc
   ```

Enjoy using these tools to streamline your Linux tasks!
