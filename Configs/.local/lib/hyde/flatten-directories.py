# This scripts flattens the directories of the path it is run in. This will be done recursively.

import os
import shutil
import sys
from datetime import datetime

def write_directory_map(directory_map):
    current_datetime = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
    with open('.map_{}'.format(current_datetime), 'w') as f:
        for file in directory_map:
            f.write(f'{file} : {directory_map[file]}\n')

def search_directory_maps():
    directory_maps = []
    for root, dirs, files in os.walk('.'):
        for file in files:
            if file.startswith('.map_'):
                directory_maps.append(file)
    return directory_maps

def read_directory_map():
    maps = search_directory_maps()
    if len(maps) == 0:
        print('No directory map found. Exiting...')
        sys.exit(1)
    else:
        print('Select a directory map to use:')
        for i, map in enumerate(maps):
            print(f'{i+1}. {map}')
        choice = int(input('Enter the number of the directory map to use: '))
        if choice < 1 or choice > len(maps):
            print('Invalid choice. Exiting...')
            sys.exit(1)
        with open(maps[choice-1], 'r') as f:
            directory_map = {}
            for line in f:
                file, directory = line.split(' : ')
                directory_map[file] = directory.replace('\n', '')
        return directory_map
    # directory_map = {}
    # with open('.map', 'r') as f:
    #     for line in f:
    #         file, directory = line.split(' : ')
    #         directory_map[file] = directory.replace('\n', '')
    # return directory_map

def create_directory_map():
    directory_map = {}
    for root, dirs, files in os.walk('.'):
        for file in files:
            directory_map[file] = root
    return directory_map

def flatten_directories(directory_map):
    # Saves the directory map as .map
    write_directory_map(directory_map)
    for file in directory_map:
        shutil.move(os.path.join(directory_map[file], file), file)

def clear_directories():
#only clears the directories leaves the files
    for root, dirs, files in os.walk('.'):
        for dir in dirs:
            shutil.rmtree(dir)

def remove_empty_dirs():
    # This function removes all empty directories in the specified path recursively.
    for root, dirs, files in os.walk('.', topdown=False):
        # Iterate directories from the bottom up, to make sure we check all subdirectories first.
        for directory in dirs:
            dirpath = os.path.join(root, directory)
            # Check if the directory is empty
            if not os.listdir(dirpath):
                # The directory is empty, remove it
                os.rmdir(dirpath)

def recreate_directories(directory_map):
    for file in directory_map:
        os.makedirs(directory_map[file], exist_ok=True)

def undo_flatten_directories(directory_map):
    new_directory_map = create_directory_map()
    recreate_directories(directory_map)
    for file in directory_map:
        shutil.move(os.path.join(new_directory_map[file], file), os.path.join(directory_map[file], file))

def reorganize_files_by_extension():
    directory_map = create_directory_map()
    write_directory_map(directory_map)
    for file in directory_map:
        extension = file.split('.')[-1]
        if "map_" in extension and file.startswith(".map_"):
            continue
        elif extension == file:
            os.makedirs('no_extension', exist_ok=True)
            shutil.move(file, os.path.join('no_extension', file))
        elif "." + extension == file:
            os.makedirs('no_extension', exist_ok=True)
            shutil.move(file, os.path.join('no_extension', file))
        else:
            os.makedirs(extension, exist_ok=True)
            shutil.move(file, os.path.join(extension, file))

if __name__ == '__main__':
    if len(sys.argv) == 1:
        check = input('Do you want to flatten the directories of the current path? [y/n]: ')
        if check.lower() != 'y':
            sys.exit(0)
        directory_map = create_directory_map()
        flatten_directories(directory_map)
        clear_directories()
    elif sys.argv[1] == '-f':
        check = input('Do you want to flatten the directories of the current path? [y/n]: ')
        if check.lower() != 'y':
            sys.exit(0)
        directory_map = create_directory_map()
        flatten_directories(directory_map)
        clear_directories()
    elif sys.argv[1] == '-u':
        check = input('Do you want to undo the flattening of the directories of the current path? [y/n]: ')
        if check.lower() != 'y':
            sys.exit(0)
        directory_map = read_directory_map()
        undo_flatten_directories(directory_map)
        remove_empty_dirs()
    elif sys.argv[1] == '-c':
        check = input('Do you want to clear the directories of the current path? (same as rm -rf) [y/n]: ')
        if check.lower() != 'y':
            sys.exit(0)
        clear_directories()
    elif sys.argv[1] == '-r':
        check = input('Do you want reorganize the current directory by extensions? (This will first flatten the directories.) [y/n]: ')
        if check.lower() != 'y':
            sys.exit(0)
        directory_map = create_directory_map()
        flatten_directories(directory_map)
        clear_directories()
        reorganize_files_by_extension()
    elif sys.argv[1] == '-h':
        print(
            "Usage: python flatten-directories.py [option]\n"
            "Options:\n"
            "  -f    Flattens the directories, moving all files to the main directory. This is the default action if no option is specified.\n"
            "  -u    Reverses the flattening process, but note that empty directories are permanently deleted.\n"
            "  -c    Removes everything within the directory, equivalent to 'rm -rf'.\n"
            "  -h    Displays this help message.\n"
            "  -r    Reorganizes the current directory by extensions. This will first flatten the directories."
        )
    else:
        print('Invalid argument')
        sys.exit(1)
