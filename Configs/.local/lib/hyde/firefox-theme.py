import os
import sys

with open("/home/riops/.cache/wal/colors.css", "r") as f:
    colors = f.read()

# Create a dictionary of colors colors
color_dict = {}

for line in colors.splitlines():
    if "--" in line and "url" not in line:
        color = line.split(": ")[0].strip().replace(";", "").replace("--", "")
        value = line.split(": ")[1].strip().replace(";", "").replace("--", "")
        color_dict[color] = value


# Now we use the colors in the firefox theme
replacement_dict = {
        "--gnome-window-background": "background",
        "--gnome-accent": "color4",
        "--gnome-card-background": "background",
        "--gnome-menu-background": "background",
        "--gnome-headerbar-background": "background",
        "--gnome-headerbar-shade-color": "foreground",
        "--gnome-tabbar-tab-hover-background": "color8",
        "--gnome-tabbar-tab-active-background": "color7"
        }

with open ("/home/riops/.mozilla/firefox/zcmjv6t6.default-release/chrome/firefox-gnome-theme/theme/colors/dark.css", "r") as f:
    theme = f.read()

for line in theme.splitlines():
    for key, value in replacement_dict.items():
        if key in line:
            color_dict[replacement_dict[key]]

