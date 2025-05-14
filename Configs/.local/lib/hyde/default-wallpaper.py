# This project will open the ~/.config/hypr/startup.conf file and change the wallpaper in that file. line starts with swaybg -m fill -i ~/.wallpapers/ and the wallpaper name will be the parameter of the script

import os
import sys

# Get the wallpaper name from the parameter
wallpaper = sys.argv[1]

# Open the startup.conf file
with open(os.path.expanduser('~/.config/hypr/startup.conf'), 'r') as f:
    lines = f.readlines()


# Change the wallpaper name in the file
for i in range(len(lines)):
    if lines[i].startswith('exec-once = swaybg -m fill -i ~/.wallpapers/'):
        lines[i] = 'exec-once = swaybg -m fill -i ~/.wallpapers/' + wallpaper + '\n'

# Write the changes to the file
with open(os.path.expanduser('~/.config/hypr/startup.conf'), 'w') as f:
    f.writelines(lines)

# Now change the swaylock wallpaper
with open(os.path.expanduser('~/.config/swaylock/config'), 'r') as f:
    lines = f.readlines()

for i in range(len(lines)):
    if lines[i].startswith('image'):
        lines[i] = 'image=~/.wallpapers/' + wallpaper + '\n'

with open(os.path.expanduser('~/.config/swaylock/config'), 'w') as f:
    f.writelines(lines)

# Now open the colors file in the ~/.cache/wal colors-waybar.css file and remove the @define-color parts and add : after the colors[number] parts

with open(os.path.expanduser('~/.cache/wal/colors-waybar.css'), 'r') as f:
    lines = f.readlines()

for i in range(len(lines)):
    if lines[i].startswith('@define-color '):
        lines[i] = lines[i].replace('@define-color ', '\t\t')
        lines[i] = lines[i].split(' ')[0] + ': ' + lines[i].split(' ')[1]

with open(os.path.expanduser('~/.cache/wal/colors.rasi'), 'w') as f:
    f.writelines('* {\n')
    f.writelines(lines)
    f.writelines('}\n')

