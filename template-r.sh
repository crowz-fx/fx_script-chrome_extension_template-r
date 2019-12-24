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
    echo ""
    if [ "$#" -eq 0 ]; then
        interactive=true
        echo "Interactive mode activated..."
        echo ""
        echo "Enter the following details;"
        echo ""
        
        read -p "--> Name of extension: " ext_name
        read -p "--> Short name of extension: " ext_short_name
        read -p "--> Description of extension: " ext_description
        read -p "--> Author of extension (your name duh!): " ext_author 

        echo ""
        read -p "Do you want to set optional parameters? (y/n): " add_optional_args
        if [[ $add_optional_args == "y" ]]; then
            read -p "--> Enter full path where to output package (leave blank for current dir): " output_location_dir_input
            if [[ $output_location_dir_input != "" ]]; then
                output_location_dir=$output_location_dir_input
            fi

            read -p "--> Extension permissions to request on installation (can be blank, comma seperated): " ext_permissions

            read -p "--> Would you like to add git control to this package? (y/n): " use_git_control
            if [[ $use_git_control == "y" ]]; then
                git_init=true
                read -p "--> Custom initial commit message? (press enter for default of '${git_commit_msg}'): " git_commit_msg_input

                if [[ $git_commit_msg_input != "" ]]; then
                    git_commit_msg=$git_commit_msg_input
                fi
            fi
        fi
    elif [ "$#" -gt 1 ]; then
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
}

echo_out_final_output() {
    echo ""
    echo "Created templated project in [${full_path_to_package}]!"
    echo ""
    echo "To-do for you;"
    echo ">    1. Add in proper icons in ${folder_name}/icons"
    echo ">    2. Crack-on and develop your extension!"
    echo ""
    echo "Thanks for using template-r!"
    echo "" 
    echo "Author; Lui Crowie (https://github.com/crowz-fx)"
}

create_package() {
    echo ""
    echo "Creating package..."
    if [ -d $full_path_to_package ]; then
        echo "Folder to create the package in already exists, exiting..."
        echo ""
        exit 1
    fi

    mkdir -p $full_path_to_package
    cp -R "`pwd`/base_template/" $full_path_to_package
    
    find ${full_path_to_package} -type f -exec sed -i 's/%%TEMPLATE_NAME%%/${ext_name}/g' {} +

    #%%TEMPLATE_SHORT_NAME%%
    #%%TEMPLATE_AUTHOR%%
    #%%TEMPLATE_DESCRIPTION%%
    #%%TEMPLATE_PERMISSIONS%%
}

echo ""
echo "Running template-r..."
handle_input "$@"
echo_out_variables
create_package
echo_out_final_output
echo ""
