#!/bin/bash

# This is a simple test for the script that checks if a git branch is stale and,
# if so, asks for confirmation before deleting it.

# Set the stale threshold (in days)
STALE_THRESHOLD=7

# Set the path to the script
SCRIPT_PATH="/path/to/script/delete_stale_branches.sh"

# Create a test repository
rm -rf test_repo
mkdir test_repo
cd test_repo
git init

# Create a stale branch
git checkout -b stale_branch
touch test.txt
git add test.txt
git commit -m "Initial commit"

# Set the last commit date of the stale branch to be older than the stale threshold
OLD_DATE=$(($(date +%s) - $((STALE_THRESHOLD + 1)) * 3600 * 24))
git commit --amend --no-edit --date "$OLD_DATE"

# Run the script and check if it asks for confirmation before deleting the stale branch
OUTPUT=$($SCRIPT_PATH <<< "y")
if [[ $OUTPUT != *"Delete stale branch 'stale_branch'? (y/n) Deleted stale branch: stale_branch"* ]]; then
  echo "Test failed: script did not ask for confirmation before deleting stale branch"
  exit 1
fi

# Check if the stale branch was actually deleted
if git branch | grep -q "stale_branch"; then
  echo "Test failed: stale branch was not deleted"
  exit 1
fi

echo "Test passed"
