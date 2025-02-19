#!/bin/bash
# script sends notification on DevOps Auto Notification teams channel on job failure
echo "Sending notification to Teams channel"
#payload=$(echo '{}' | jq --arg text "GitHub Actions workflow failed on branch: "$GITHUB_REF". [View details]("$GITHUB_URL"/"$GITHUB_REPO"/actions/runs/"$GITHUB_RUN")" '{ text: $text }')
#curl -H "Content-Type: application/json" -d "$payload" "$TEAMS_WEBHOOK_URL"
echo "GitHub Actions workflow failed on "$FAILED_JOB_NAME" on branch: "$GITHUB_REF" .\n\n Author: "$GITHUB_USER".\n\n PR_LINK: "$PR_LINK"  \n\n[View details]("$GITHUB_URL"/"$GITHUB_REPO"/actions/runs/"$GITHUB_RUN")"
