#!/bin/bash

branch_name="$1"

git checkout $branch_name

mvn versions:set -DnewVersion="$1-SNAPSHOT"
mvn versions:commit

git add pom.xml
git add */pom.xml

commit_msg="bump_version.sh $1-SNAPSHOT"

git commit -m "\"$commit_msg\""
git push --set-upstream origin $branch_name

echo "Bumped to $branch_name"