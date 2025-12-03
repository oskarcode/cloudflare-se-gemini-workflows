#!/bin/bash

# Directory where screenshots are saved
DESKTOP_DIR="/Desktop/screenshots"

# Path to the prompt file, the location for the .md prompt file
PROMPT_FILE="/screen_explainer.md"

# Find the most recent screenshot on the desktop
# Assumes the default macOS screenshot filename pattern "Screenshot..."
echo "Scanning Desktop for recent screenshots (debug):" >&2
ls -lt "$DESKTOP_DIR"/Screenshot* 2>/dev/null | head -n 5 >&2 || echo "  (no matching Screenshot* files)" >&2

# LATEST_SCREENSHOT must be the full path to the newest screenshot file
LATEST_SCREENSHOT=$(ls -t "$DESKTOP_DIR"/Screenshot* 2>/dev/null | head -n 1)

if [ -z "$LATEST_SCREENSHOT" ]; then
    echo "No screenshot files found on the desktop with the pattern 'Screenshot*'." >&2
    exit 1
fi

echo "Using latest screenshot file: $LATEST_SCREENSHOT" >&2

# Check if the prompt file exists
if [ ! -f "$PROMPT_FILE" ]; then
    echo "Error: Prompt file not found at $PROMPT_FILE"
    exit 1
fi

# Read the prompt from the file
PROMPT_CONTENT=$(cat "$PROMPT_FILE")

# Path to the gemini executable
GEMINI_PATH="/opt/homebrew/bin/gemini"

# Call Gemini with the screenshot and the prompt
echo "Sending screenshot to Gemini for analysis..." >&2
# Send Gemini CLI logs to stderr (/dev/null) so stdout only contains the model's answer
$GEMINI_PATH -p "@$LATEST_SCREENSHOT $PROMPT_CONTENT" --yolo -m gemini-2.5-flash 2>/dev/null


