#!/bin/bash

# Minimal screenshot explainer: find latest screenshot and call Gemini once.

# Directory where screenshots are saved
DESKTOP_DIR="Desktop/{}/screenshots"

# Path to the prompt file
PROMPT_FILE="/{}/screen_explainer.md"

# Find the most recent screenshot (full path)
LATEST_SCREENSHOT=$(ls -t "$DESKTOP_DIR"/Screenshot* 2>/dev/null | head -n 1)

if [ -z "$LATEST_SCREENSHOT" ]; then
    echo "No screenshot files found in $DESKTOP_DIR matching 'Screenshot*'." >&2
    exit 1
fi

# Ensure prompt file exists
if [ ! -f "$PROMPT_FILE" ]; then
    echo "Prompt file not found at $PROMPT_FILE" >&2
    exit 1
fi

# Read the prompt from the file
PROMPT_CONTENT=$(cat "$PROMPT_FILE")

# Path to the Gemini executable
GEMINI_PATH="/opt/homebrew/bin/gemini"

# Call Gemini with the screenshot and the prompt; suppress CLI logs so stdout is only the answer
"$GEMINI_PATH" -p "@$LATEST_SCREENSHOT $PROMPT_CONTENT" --yolo -m gemini-2.5-flash 2>/dev/null


