#!/bin/bash

# This script calculates the effective version of the module and stores it in version.txt

# Read the current version
current_version=$(cat version.txt)
# Get the last tag name
var=$(echo $git_tag | awk -F '-' {'print $1'})
var2=$(echo $git_tag | awk -F '-' {'print $2'})
current_version=$(echo $var.$var2)

# Check if the current version in the expected format
[[ $current_version =~ ^([0-9]|[1-9][0-9]*)\.([0-9]|[1-9][0-9]*)\.([0-9]|[1-9][0-9]*)$ ]] && echo "valid version" || { echo "invalid version. exiting" ; exit 1; }

# Get the major_version, minor_vesion and patch
major_version=`echo $current_version | cut -f1 -d "."`
minor_version=`echo $current_version | cut -f2 -d "."`
patch=`echo $current_version | cut -f3 -d "."`

echo $major_version $minor_version $patch

commit_msg=$(git log -1 --format=%s)

filtered_commit=`echo $commit_msg | cut -f2 -d ":"`

if [[ $filtered_commit =~ "MAJOR" ]] ; then
    major_version=$(( major_version + 1 ))
elif [[ $filtered_commit  =~ "MINOR"  ]] ; then
    minor_version=$(( minor_version + 1 ))
fi

patch=$CODEBUILD_BUILD_NUMBER

# Update version.txt
echo $major_version.$minor_version.$patch > version.txt