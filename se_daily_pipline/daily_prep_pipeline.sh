#!/bin/bash

# Minimal SE daily prep pipeline: just read the prompt and call Gemini once.

# Path to Gemini CLI
GEMINI_PATH="{}/gemini"

# Path to the prompt file (update if you move the repo)
PROMPT_FILE_PATH="{}/se_daily_prep_prompt.md"

# Model flag
MODEL_FLAG="-m gemini-2.5-flash"

# Read prompt content
PROMPT_CONTENT=$(cat "$PROMPT_FILE_PATH")

# Execute Gemini headless with the prompt; print output directly
"$GEMINI_PATH" --yolo $MODEL_FLAG "$PROMPT_CONTENT"
