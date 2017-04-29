#!/bin/bash

branch_name="$1"

git checkout -b $branch_name

mvn versions:set -DnewVersion="$1-SNAPSHOT"
mvn versions:commit

git add pom.xml
git add */pom.xml
git commit -m 'bump_version.sh $1-SNAPSHOT'
git push --set-upstream origin $branch_name

echo "Bumped to $branch_name"