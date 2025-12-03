#!/bin/bash

# --- Configuration: Paths Provided by User ---
GEMINI_PATH="/opt/homebrew/bin/gemini"
PROMPT_FILE_PATH="/Users/oskarablimit/.gemini/se_daily_pipline/se_daily_prep_prompt.md"

# --- Logging Setup (Retained for audit trail) ---
LOG_DIR="/Users/oskarablimit/.gemini/se_daily_pipline/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/prep_pipeline_$(date +\%Y\%m\%d_\%H\%M\%S).log"


# --- Execution ---
echo "--- 🚀 Pipeline Run Start: $(date) ---" > "$LOG_FILE"
echo "--- Pipeline Config ---" >> "$LOG_FILE"
echo "Gemini Path: $GEMINI_PATH" >> "$LOG_FILE"
echo "Prompt Path: $PROMPT_FILE_PATH" >> "$LOG_FILE"
echo "Executing command (Default Model)..." >> "$LOG_FILE"

# Read the prompt content from the file
# Define the Model Flag to avoid capacity errors
# export INTERACTIVE=0
MODEL_FLAG="-m gemini-2.5-flash"
PROMPT_CONTENT=$(cat "$PROMPT_FILE_PATH")
COMMAND_TO_RUN="$GEMINI_PATH --yolo $MODEL_FLAG \"$PROMPT_CONTENT\""

# 1. Execute the command: ALL execution output is directed to a temp file.
TEMP_OUTPUT_FILE=$(mktemp)
eval "$COMMAND_TO_RUN" > "$TEMP_OUTPUT_FILE" 2>&1

EXIT_STATUS=$?

# 2. Filter the output: Only write lines containing errors, final status, or key action verbs to the main log.

# Filter lines indicating progress, errors, or final state
grep -E '^(Got it|Okay|Now|Attempt [0-9]+ failed|Error|Exhausted|Final Output|Conclusion|✅|❌|No customer meetings)' "$TEMP_OUTPUT_FILE" >> "$LOG_FILE"

# Append the full API error report if the status was bad
if [ $EXIT_STATUS -ne 0 ]; then
    echo "--- FULL API ERROR REPORT ---" >> "$LOG_FILE"
    # Capture the specific API Error message from the end of the log
    # grep -E '(\[API Error|critical error occurred:)' "$TEMP_OUTPUT_FILE" >> "$LOG_FILE"
    echo "--- Raw output from command ---" >> "$LOG_FILE"
    cat "$TEMP_OUTPUT_FILE" >> "$LOG_FILE"
fi

# --- Confirmation ---
echo "--- Conclusion ---" >> "$LOG_FILE"
if [ $EXIT_STATUS -eq 0 ]; then
    echo "✅ Pipeline command executed successfully (Exit Status 0)." >> "$LOG_FILE"
else
    echo "❌ Pipeline command FAILED with Exit Status $EXIT_STATUS." >> "$LOG_FILE"
fi

echo "--- Pipeline Run End: $(date) ---" >> "$LOG_FILE"
rm "$TEMP_OUTPUT_FILE"