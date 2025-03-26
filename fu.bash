#!/bin/bash
# fu: A utility to interact with clipboard and files

# Function to resolve full path
resolve_path() {
    local path="$1"
    
    # Expand tilde if the path starts with ~
    if [[ "$path" == ~* ]]; then
        path="${path/#\~/$HOME}"
    fi
    
    # If path is relative, convert to absolute path
    if [[ "$path" != /* ]]; then
        path="$(pwd)/$path"
    fi
    
    # Normalize path (remove ./ and ../)
    path=$(readlink -f "$path")
    
    echo "$path"
}


# Function to show usage
show_usage() {
    echo "Usage:"
    echo "  fu paste [default_filename]  - Paste clipboard content to a file"
    echo "  fu clip [search_path]        - Select a text file to load into clipboard"
    echo "                                 Defaults to current directory if no path specified"
    exit 1
}

find_text_files() {
    local search_path="${1:-.}"  # Use provided path or current directory
    find "$search_path" -type f 2>/dev/null
}

# Check for the correct subcommand
case "$1" in
    paste)
        # Original paste functionality
        shift
        default_file=$([ -n "$1" ] && resolve_path "$1")

        # Retrieve clipboard content using xclip
        clipboard=$(xclip -selection clipboard -o 2>/dev/null)
        if [ $? -ne 0 ]; then
            echo "Error: Unable to retrieve clipboard content. Is xclip installed?"
            exit 1
        fi

        # Display the clipboard content
        echo "Clipboard content:"
        echo "------------------"
        echo "$clipboard"
        echo "------------------ ^ Clipboard content ^"

        # Prompt for the file to write to
        if [ -n "$default_file" ]; then
            read -p "Enter file to write to (default: $default_file): " file
            file=${file:-$default_file}
        else
            read -p "Enter file to write to: " file
        fi

        if [ -z "$file" ]; then
            echo "No file specified. Exiting."
            exit 1
        fi

        # Expand tilde if the file path starts with ~
        if [[ "$file" == ~* ]]; then
            file="${file/#\~/$HOME}"
        fi

        # Check if the file exists
        if [ ! -e "$file" ]; then
            read -p "File '$file' does not exist. Create new? (Y)es or (C)ancel: " choice
            case "$choice" in
                [Yy])
                    echo "$clipboard" > "$file"
                    echo "Created new file '$file' and wrote clipboard content."
                    ;;
                *)
                    echo "Operation cancelled."
                    exit 0
                    ;;
            esac
        else
            read -p "File '$file' exists. (A)ppend, (O)verwrite, or (C)ancel? " choice
            case "$choice" in
                [Aa])
                    echo "$clipboard" >> "$file"
                    echo "Appended clipboard content to '$file'."
                    ;;
                [Oo])
                    echo "$clipboard" > "$file"
                    echo "Overwritten '$file' with clipboard content."
                    ;;
                *)
                    echo "Operation cancelled."
                    exit 0
                    ;;
            esac
        fi
        ;;

    clip)
        # Determine input path
        shift
        input_path="${1:-.}"  # Use provided path or current directory

        # Resolve the input path
        input_path=$(resolve_path "$input_path")

        # If input is a file, directly copy its content
        if [ -f "$input_path" ]; then
            xclip -selection clipboard < "$input_path"
            echo "Copied content of '$input_path' to clipboard."
            exit 0
        fi

        # If input is not a directory, throw an error
        if [ ! -d "$input_path" ]; then
            echo "Error: '$input_path' is not a valid directory or file."
            exit 1
        fi
        # Find and select a text file
        selected_file=$(find_text_files "$input_path" | fzf --preview 'head -n 20 {}')

        # Check if a file was selected
        if [ -z "$selected_file" ]; then
            echo "No file selected. Exiting."
            exit 0
        fi

        # Copy file content to clipboard
        xclip -selection clipboard < "$selected_file"
        echo "Copied content of '$selected_file' to clipboard."
        ;;

    *)
        show_usage
        ;;
esac
