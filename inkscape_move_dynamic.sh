#!/bin/bash
# Inkscape launcher with workspace move

FILE="$1"

# Launch Inkscape with or without a file
if [ -n "$FILE" ]; then
    inkscape "$FILE" &
else
    inkscape &
fi

# Give it a moment to start
sleep 1

# Function to move all Inkscape windows to workspace 5
move_inkscape_windows() {
    for WIN_ID in $(hyprctl clients | grep "org.inkscape.Inkscape" | awk '{print $1}'); do
        hyprctl dispatch movetoworkspace special
        # Optional: make it floating
        # hyprctl dispatch toggletiled $WIN_ID
    done
}

# Initial move
move_inkscape_windows

# Watch for new windows spawned by Inkscape
for i in {1..10}; do
    sleep 0.5
    move_inkscape_windows
done
