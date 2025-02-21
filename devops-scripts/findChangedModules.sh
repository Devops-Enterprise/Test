#!/bin/bash

git config --global --add safe.directory /__w/mortgagesfdc-homes-crm/mortgagesfdc-homes-crm #fix for dubious ownership issue TODO check more deeply for better solution

source_to_check_changes="origin/$GITHUB_BASE_REF"
current_branch="origin/${GITHUB_HEAD_REF:-${GITHUB_REF_NAME}}"

if [ -n "$1" ]; then
  source_to_check_changes=$1
fi

git fetch origin
git_diff=$(git diff --name-only $source_to_check_changes...$current_branch | grep -v "^src/")

# Check changes outside src folder
if [[ -n $DEVOPS_TEAM && -n $git_diff ]]; then

  IFS=$'\n' read -r -d '' -a DEVOPS_ARRAY <<< "$(echo "$DEVOPS_TEAM" | sed '/^\s*$/d' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  is_admin=false

  for member in "${DEVOPS_ARRAY[@]}"; do
    if [[ "$member" == "$GITHUB_ACTOR" ]]; then
      is_admin=true
      break
    fi
  done

  # Check if user is NOT in DevOps team
  if ! $is_admin; then
    IFS=$'\n' read -r -d '' -a ALLOWED_DEV_MODIFICATIONS_ARRAY <<< "$(echo "$ALLOWED_DEV_MODIFICATIONS" | sed '/^\s*$/d' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

    while IFS= read -r file; do
      is_allowed=false
      for allowed_modification in "${ALLOWED_DEV_MODIFICATIONS_ARRAY[@]}"; do
        if [[ "$file" == "$allowed_modification"* ]]; then
          is_allowed=true
          break
        fi
      done

      if ! $is_allowed; then
        echo "Only DevOps team members can change '$file'."
        exit 1
      fi
    done <<< "$git_diff"
  fi
fi

echo "Starting to look for changed modules against $source_to_check_changes..."
# Array of your module directories
modules=( $( cd src/ ;ls -1p | grep / | sed 's/^\(.*\)/\1/') )

 #externalize module names
# Base branch to compare against, adjust according to your workflow

 
# Loop through each module to check for changes
for module in "${modules[@]}"; do
    # Check if the module has changes compared to the base branch
    if git diff --name-only "$source_to_check_changes" | grep -q "$module"; then
        changed_modules+=("$module")
        echo "changes detected in $module"
    else
        echo "No changes in $module"
    fi
done

if (( ${#changed_modules[@]} == 0 )); then
  echo "No changed modules detected"
else
  echo "--- Changes detected for modules ${changed_modules[*]}"
  echo "changed_modules=${changed_modules[*]}" >> "$GITHUB_OUTPUT"
fi
echo

# TODO below code ideally should to be rewritten into single mechanism of changes analyser module, instead having another git diff call
deleted_files=$(git diff $source_to_check_changes --name-status --diff-filter=D)
if [ -n "$deleted_files" ]; then
  echo "Deleted files found:"
  echo "$deleted_files"
  echo "deleted_files_found=true" >> "$GITHUB_OUTPUT"
else
  echo "No deleted files found."
fi