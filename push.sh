#!/bin/bash

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
# ex. curl -u "git4m2" https://api.github.com/user/repos -d "{ \"name\": \"GitBash\" }"
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


# PARSE LOCAL PROJECT DIRECTORY PATH INTO ARRAY
#localProjectDirPath="C:/Projects/<PROJECTNAME>"
#localProjectDirPath="fatal: Not a git repository (or any of the parent directories): .git"
localProjectDirPath=`git rev-parse --show-toplevel 2>&1`
IFS=':' read -r -a array <<< "$localProjectDirPath"
localExists=${array[0]}

# DETERMINE IF PROJECT EXISTS IN LOCAL REPOSITORY
if [ "$localExists" = "fatal" ]; then
    echo ""
    echo "Create local Git repository."
    git init
fi


# DETERMINE IF PROJECT EXISTS IN REMOTE REPOSITORY (i.e. GitHub)
#Example...
#From https://github.com/git4m2/<PROJECTNAME>.git
#5380a81b26547fa5adb3ae05219a283be9ab87d8        HEAD
#5380a81b26547fa5adb3ae05219a283be9ab87d8        refs/heads/master
#cd212bcce27a117f00d99b47029ab6f701835cb9        refs/tags/v1.0
#5380a81b26547fa5adb3ae05219a283be9ab87d8        refs/tags/v1.0^{}
#Alternatively...
#fatal: No remote configured to list refs from.
remoteExists=`git ls-remote --exit-code 2>&1`
IFS=':' read -r -a array <<< "$remoteExists"
remoteExists=${array[0]}


if [ "$remoteExists" = "fatal" ]; then
    echo ""
    echo "Remote project does \"not\" exist."
    
    # LOCAL PROJECT DIRECTORY PATH
	localProjectDirPath=`git rev-parse --show-toplevel 2>&1`

    echo ""
    echo "Current Local Project Directory Path"
    echo "$localProjectDirPath"

    # PARSE LOCAL PROJECT DIRECTORY PATH INTO ARRAY
    IFS='/' read -r -a array <<< "$localProjectDirPath"
    arrayLength=${#array[@]}
    projectName=${array[$arrayLength - 1]}
    
    echo ""
    echo "Suggested Project Name: "
    echo "$projectName"
    
    # CONFIRM PROJECT NAME
    echo ""
    read -p "Accept Suggested Project Name (y/n)? " respProjName
    
    if [ "$respProjName" != "y" ]; then
        # CONFIRM ALTERNATE PROJECT NAME
        echo ""
        read -p "Type an alternate project name: " projectName
        echo "Alternate Project Name: $projectName"
        
        echo ""
        read -p "Is this correct (y/n)? " respAltProjName
        
        if [ "$respAltProjName" != "y" ]; then
            echo ""
            echo "Alternate project name confirmation failed."
            exit 1
        else
            echo ""
            echo "Alternate project name \"$projectName\" confirmed."
        fi
    else
        echo ""
        echo "Project name \"$projectName\" confirmed."
    fi
else
    echo ""
    echo "Remote project does exist."
fi


# PROCESSING
username=`git config user.name`

if [ "$remoteExists" = "fatal" ]; then
    echo ""
    echo "Create remote Git repository \"$projectName\" with account \"$username\"."
    curl -u "$username" https://api.github.com/user/repos -d "{ \"name\": \"$projectName\" }"
fi

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

if [ "$remoteExists" = "fatal" ]; then
    echo ""
    echo "Add project to remote repository..."
    git remote add origin https://github.com/$username/$projectName.git
fi

echo ""
echo "Push Files (remote repo)..."
git push -u origin master
#git status

echo ""
echo "Push Tags (remote repo)..."
git push origin "v$ver" --tags
#git status

echo ""
echo "Commit, tag and push to remote repository complete."
