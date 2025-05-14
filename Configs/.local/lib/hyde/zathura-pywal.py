import os

def hex_to_rgb(hex):
    hex = hex.lstrip('#')
    return tuple(int(hex[i:i+2], 16) for i in (0, 2, 4))

def read_colors():
    colors = {}
    with open(os.path.expanduser("~/.cache/wal/colors.scss"), "r") as f:
        for line in f:
            if line.startswith("$") and "wallpaper" not in line:
                line = line.replace("$", "").replace(":", "").replace(";", "").split()
                colors[line[0]] = line[1]

    return colors

def write_colors():
    color_dict = {
        "completion-bg": "color0",
        "completion-fg": "color15",
        "completion-group-bg": "color0",
        "completion-group-fg": "color15",
        "completion-highlight-bg": "color3",
        "completion-highlight-fg": "color15",
        "default-bg": "color0",
        "default-fg": "color15",
        "inputbar-bg": "color0",
        "inputbar-fg": "color15",
        "notification-error-bg": "color1",
        "notification-error-fg": "color15",
        "notification-warning-bg": "color3",
        "notification-warning-fg": "color15",
        "statusbar-bg": "color0",
        "statusbar-fg": "color15",
        "highlight-color": "color3",
        "highlight-active-color": "color3",
        "recolor-lightcolor": "color15",
        "recolor-darkcolor": "color0",
        "render-loading-bg": "color0",
        "render-loading-fg": "color15",
        "index-fg": "color15",
        "index-bg": "color0",
        "index-active-fg": "color15",
        "index-active-bg": "color3"
    }
    with open(os.path.expanduser("~/.config/zathura/zathurarc"), "w") as f:
        for key, value in color_dict.items():
            f.write(f"set {key} #{colors[value]}\n")
    

