#!/bin/bash

# This script checks if a git branch is stale and, if so, asks for confirmation
# before deleting it.

# Set the stale threshold (in days)
STALE_THRESHOLD=7

# Get a list of all local branches
branches=`git branch`

# Iterate over each branch
for branch in $branches; do
  # Check if the branch is stale
  last_commit_date=`git log -1 --pretty=format:%ct $branch`
  current_date=`date +%s`
  diff=$(( (current_date - last_commit_date) / (3600 * 24) ))
  if [[ $diff -gt $STALE_THRESHOLD ]]; then
    # Ask for confirmation before deleting the stale branch
    read -p "Delete stale branch '$branch'? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      git branch -D $branch
      echo "Deleted stale branch: $branch"
    fi
  fi
done
