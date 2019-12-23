#/bin/bash

# -----
# Defaults for the extension
# -----
# Required parameters
ext_name="Amazing Extension"
ext_short_name="Shorty"
ext_description="What a great extension"
ext_author="Joe Bloggs"
# Optional parameters
output_location_dir=$(cwd)
ext_permissions=""
git_init=false
git_commit_msg="Initial commit and setup"

for input in "$@"
do
    echo $input
done

echo 'running'