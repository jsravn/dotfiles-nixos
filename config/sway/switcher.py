#!/usr/bin/env python
#
# Modified from https://github.com/varesa/dotfiles/blob/master/.config/sway/switch_window.py.

import subprocess
import json

def handle_container(con):
    """
    Recursively find all windows
    """

    windows = []

    if 'app_id' in con.keys():
        app_id = con['id']
        app_name = con['app_id'] if con['app_id'] else con['window_properties']['class']
        app_title = con['name']

        windows.append((app_id, app_name, app_title,))

    for child in con['nodes']:
        windows = windows + handle_container(child)

    return windows


tree = json.loads(subprocess.check_output(['swaymsg', '-t', 'get_tree']))
windows = []

# Find all workspaces and the windows in them
for output in tree['nodes']:
    for workspace in output['nodes']:
        if 'nodes' not in workspace.keys():
            continue

        for container in workspace['nodes']:
            windows = windows + handle_container(container)
        for container in workspace['floating_nodes']:
            windows = windows + handle_container(container)

# Format the list of windows for dmenu/rofi
windows_string = '\n'.join([f"<{app_id}> {app_name} --- {app_title}" for app_id, app_name, app_title in windows])

active_display = subprocess.check_output("swaymsg -t get_outputs -p | grep Output | awk '{print NR-1 $s}' | grep focused | cut -c 1", shell=True).decode().strip()

# Call rofi and move focus to the selected window
selection = subprocess.check_output(['rofi', '-dmenu', '-i', '-m', '' + active_display], input=windows_string, universal_newlines=True)
window_id = selection.split(' ')[0][1:-1]
subprocess.call(['swaymsg', f"[con_id=\"{window_id}\"]", 'focus'])
