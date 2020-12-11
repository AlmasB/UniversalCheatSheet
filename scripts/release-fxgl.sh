#!/bin/bash

version="$1"

function release_fxgl {
    echo "Running maven deploy"

    mvn -T 12 clean deploy -DskipTests=true -Dlicense.skip=true -Dpmd.skip=true
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
    echo "Releasing..."
    echo "Setting new version to $version"

    mvn versions:set -DnewVersion="$version"
    
    release_fxgl
    
    echo "Released $version"
    
    make_uber_jar
    
    mvn versions:revert
fi
