#!/bin/bash
# script sends notification on DevOps Auto Notification teams channel on job failure
# echo "Sending notification to Teams channel"
echo "Sending notification to Teams channel"
echo "$GITHUB_EVENT_SENDER_LOGIN"
payload=$(cat <<EOF
          {
            "text": "**DevOps TEST - GitHub Actions workflow failed - '$GITHUB_WORKFLOW'**",
            "sections": [
              {
                "activityTitle": " ",
                "facts": [
                        {"name": "Failed job:", "value": "$JOB_NAME"},
                        {"name": "Author:", "value": "${FULL_NAME:-$GITHUB_EVENT_SENDER_LOGIN}"},
                        {"name": "Squad:", "value": "${SQUAD_NAME:-Not provided}"},
                        {"name": "Branch/Tag:", "value": "$GITHUB_BRANCH"},
                        {"name": "PR Link:", "value": "${PR_LINK:-${GITHUB_EVENT_MERGE_COMMIT:-'Not a PR ('$GITHUB_EVENT_NAME')'}}"},
                        {"name": "Action URL:", "value": "$GITHUB_URL/$GITHUB_REPO/actions/runs/$GITHUB_RUN"}
                      ],
                "markdown": true
              }
            ]
          }
EOF
)
echo "$payload"
# Send the payload to Teams webhook
# curl -H "Content-Type: application/json" -d "$payload" "$TEAMS_WEBHOOK_URL"
#echo "GitHub Actions workflow failed on "$FAILED_JOB_NAME" on branch: "$GITHUB_REF" .\n\n Author: "$GITHUB_USER".\n\n PR_LINK: "$PR_LINK"  \n\n[View details]("$GITHUB_URL"/"$GITHUB_REPO"/actions/runs/"$GITHUB_RUN")"
