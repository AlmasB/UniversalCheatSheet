#!/bin/bash

version="$1"

function release_fxgl {
    mvn versions:set -DnewVersion="$version"
    mvn versions:commit

    git add pom.xml
    git add */pom.xml

    commit_msg="release.sh $version"

    git commit -m "\"$commit_msg\""
    git push

    echo "Running maven deploy"

    mvn -T 12 clean deploy -DskipTests=true -Dlicense.skip=true -Dpmd.skip=true

    echo "Released $version"
}

function make_uber_jar {
    echo "Running maven package"

    mvn -T 12 clean package -DskipTests=true -Dlicense.skip=true -Dpmd.skip=true -P uber-jar
    cp fxgl/target/fxgl-"$version"-uber.jar ~/Desktop
    
    echo "Packaged and copied uber-jar to Desktop"
}

if [ "$version" == "" ]; then
    echo "Please provide release version"
else
    # check if running on master branch

    branch_name="$(git rev-parse --abbrev-ref HEAD)"

    # check if any changes
    if [ "$branch_name" == "master" ]; then
        echo "Running on master branch"
        release_fxgl
        make_uber_jar
        bump_version.sh dev
    else
        echo "FXGL can only be released from master branch"
    fi
fi
