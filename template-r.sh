#/bin/sh

# -----
# Defaults for the script
# -----
# Required parameters
ext_name="Amazing Extension"
ext_short_name="Shorty"
ext_description="What a great extension"
ext_author="Joe Bloggs"
# Optional parameters
output_location_dir=`pwd`
ext_permissions=""
git_init=false
git_commit_msg="Initial commit and setup"

# -----
# Script variables
# -----
interactive=false
full_path_to_package=""
folder_name=

# $@ - all args passed in
handle_input() {
    if [ "$#" -eq 0 ]; then
        interactive=true
        echo "Interactive mode activated..."

        # TO-DO 

    elif [ "$#" -eq 1 ] && [[ $(echo "$1" | cut -d "=" -f 1) == "--params-file" ]]; then
        echo "Using text file..."
        params_file=$(echo "$1" | cut -d "=" -f 2)

        # exit out if the cut failed and just returns the full string
        if [[ $params_file == "--params-file" ]] || [[ $params_file == "" ]]; then
            echo "No path supplied!"
            error_out_displaying_usage
        fi

        echo "Pulling parameters from [${params_file}]..."
        file_contents=read_in_params_file
        
    elif [ "$#" -gt 3 ]; then
        echo "Using parameters passed in..."

        # TO-DO
        for input in "$@"
        do
            echo $input
        done
    else 
        error_out_displaying_usage
    fi

    folder_name=$(echo $(echo "${ext_name}" | tr "[:upper:]" "[:lower:]") | tr "[ ]" "[_]")
    full_path_to_package="${output_location_dir}/${folder_name}"
}

error_out_displaying_usage() {
    echo ""
    echo "Incorrect arguments used... exiting!"
    echo ""
    exit 1
}

echo_out_variables() {
    echo ""
    echo "Using the following input..."
    echo ">    extension_name=${ext_name}"
    echo ">    extension_short_name=${ext_short_name}"
    echo ">    extension_description=${ext_description}"
    echo ">    extension_author=${ext_author}"
    echo ">    full_path_to_package=${full_path_to_package}"
    echo ">    extension_permissions=${ext_permissions}"
    echo ">    git_init=${git_init}"
    echo ">    git_commit_msg=${git_commit_msg}"
    echo ""
}

read_in_params_file() {
    echo ""
}

create_package() {
    echo ""
}

echo ""
echo "Running template-r..."
handle_input "$@"
echo_out_variables
create_package
echo "Created templated project at ${full_path_to_package}"
echo ""
