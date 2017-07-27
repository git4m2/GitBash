#!/bin/bash

# added this git-bash script filename to "C:\Projects\RainingChain\HTML5 Games\.git\info\exclude"

# Example Steps...
# 1. Input version: 14.1
# 2. Input description: OOPs! Refactor (end of video @ 14:10)
# 3. git status
# 4. git add index.html
# 5. git commit -m "v14.1 - OOPs! Refactor (end of video @ 14:10)"
# 6. git tag -a "v14.1" -m "14.1"
# 7. git push origin master
# 8. git push origin v14.1

# Note 7: If the origin does not yet exist, you may create it using cURL.
# ex. curl -u 'git4m2' https://api.github.com/user/repos -d '{"name":"GitBash"}'
# Remember to add the origin:
# ex. git remote add origin https://github.com/git4m2/GitBash.git
# Push existing repository:
# ex. git push -u origin master


clear


# CONFIRM VERSION
echo ""
read -p "Type a version number: " ver
echo "Version number: $ver"

echo ""
read -p "Is this correct (y/n)? " respVer

if [ "$respVer" != "y" ]; then
    echo "Version confirmation failed."
    exit 1
else
    echo "Version confirmed."
fi


# CONFIRM DESCRIPTION
echo ""
read -p "Type a commit description: " desc
echo "Commit description: $desc"

echo ""
read -p "Is this correct (y/n)? " respDesc

if [ "$respDesc" != "y" ]; then
    echo "Commit description confirmation failed."
    exit 1
else
    echo "Description confirmed."
fi


# CONFIRM PROCESSING
commitMsg="v$ver - $desc"

echo ""
echo "Version: $ver"
echo "Commit message: $commitMsg"

echo ""
read -p "Proceed with commit, tag and push to remote repository (y/n)? " respPush

if [ "$respPush" != "y" ]; then
    echo "Process confirmation failed."
    exit 1
else
    echo "Processing confirmed."
fi


# PROCESSING
echo ""
echo "Repository Status..."
git status

echo ""
echo "Stage Files..."
git add -A
git status

echo ""
echo "Commit Files (local repo)..."
git commit -m "$commitMsg"
#git status

echo ""
echo "Tag Files (local repo)..."
git tag -a "v$ver" -m "$ver"
#git status

echo ""
echo "Push Files (remote repo)..."
git push origin master
#git status

echo ""
echo "Push Tags (remote repo)..."
git push origin "v$ver"
#git status

echo ""
echo "Commit, tag and push to remote repository complete."
