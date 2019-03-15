#!/bin/bash

file_name="$1"

cp $file_name ~/almas_workspace/etc/git-server/storage/images/

cd ~/almas_workspace/etc/git-server/storage/images/

git pull

git add $file_name

commit_msg="upload.sh $1"

git commit -m "\"$commit_msg\""
git push

echo "Uploaded $file_name to git-server/storage/images/"