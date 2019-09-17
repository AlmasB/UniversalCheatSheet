#!/bin/bash

# assume running on master branch

version="$1"

mvn versions:set -DnewVersion="$1"
mvn versions:commit

git add pom.xml
git add */pom.xml

commit_msg="release.sh $1"

git commit -m "\"$commit_msg\""
git push

echo "Running maven deploy"

mvn clean deploy -DskipTests=true -Dlicense.skip=true -Dpmd.skip=true

echo "Released $version"