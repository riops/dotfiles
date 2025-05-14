function list_projects
    set projects_dir "$HOME/.index/projects.txt"

    if not test -f "$projects_dir"
        echo "No project index file found at $projects_dir"
        return 1
    end

    set target (cat "$projects_dir" | while read -l line
        set name (basename "$line")
        echo -e "$name\t$line"
    end | fzf --prompt='Choose the project directory> ' --delimiter='\t' --with-nth=1 | cut -f2)

    if test -n "$target"
        cd "$target"
    end
end

function add_project
    set projects_dir "$HOME/.index/projects.txt"

    if not test -f "$projects_dir"
        touch "$projects_dir" || return 1
    end

    set current (string trim --right --chars=/ (pwd))

    if grep -q "$current" "$projects_dir"
        echo "The path is already in the file."
        return 0
    else
        echo "$current" >> "$projects_dir"
        echo "The path has been added to the file."
        return 0
    end
end

function delete_project
    set projects_file "$HOME/.index/projects.txt"
    set current (pwd)

    if not test -f "$projects_file"
        echo "The file does not exist."
        return 1
    end

    if grep -q "$current" "$projects_file"
        sed -i "\|^$current\$|d" "$projects_file"
        echo "The path has been deleted from the file."
    else
        echo "The path is not in the file."
    end

    return 0
end

function project
    set arg (count $argv) > /dev/null

    if test $arg -eq 0
        add_project
        return 0
    end

    switch $argv[1]
        case '-h' '--help'
            echo "
Usage: project [option]

Options:
  -a    Add the current directory to the projects.txt file.
  -d    Delete the current directory from the projects.txt file, if it exists.
  -l    List all projects and allow selection to cd into the chosen one (fzf).
  -h, --help
        Show this help message.

Examples:
  project        (same as -a; adds the current dir to the project list)
  project -l     List and cd to a project
  project -d     Delete current dir from projects list
  project -h     Show this help and exit
"
            return 0

        case '-a'
            add_project
            return 0

        case '-d'
            delete_project
            return 0

        case '-l'
            list_projects
            return 0

        case '*'
            echo "Unknown option: $argv[1]"
            return 1
    end
end
