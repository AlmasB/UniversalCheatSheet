#!/bin/bash

function build_fxgl {
    echo "Running maven install"

    mvn -T 12 install -pl :fxgl -am -DskipTests=true -Dlicense.skip=true -Dpmd.skip=true

    echo "Finished building fxgl"
}

function make_image {
    echo "Running maven javafx:jlink"

    cd fxgl-tools
    mvn javafx:jlink
    cp target/fxgl-dialogue-editor.zip ~/Desktop
    
    echo "Copied jlink image to Desktop"
}

build_fxgl

make_image