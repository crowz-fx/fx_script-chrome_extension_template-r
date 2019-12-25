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
folder_name=""
# this is used in the check as bash doesn't know how to pass back Strings
global_arg_value=""

# $@ - all args passed in
handle_input() {
    # ensure the args are split into an array
    IFS="--" read -r -a passed_in_args <<< "$@"
    unset IFS

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

        if [ "$#" -lt 4 ]; then
            error_out_displaying_usage
        fi

        check_for_arg "author"
        if [ $? -eq 0 ]; then
            echo ""
            echo "No author value has been supplied!"
            error_out_displaying_usage
        else
            ext_author=$global_arg_value
        fi

        check_for_arg "name"
        if [ $? -eq 0 ]; then
            echo ""
            echo "No name for the extension has been supplied!"
            error_out_displaying_usage
        else
            ext_name=$global_arg_value
        fi

        check_for_arg "short"
        if [ $? -eq 0 ]; then
            echo ""
            echo "No short name for the extension has been supplied!"
            error_out_displaying_usage
        else
            ext_short_name=$global_arg_value
        fi

        check_for_arg "desc"
        if [ $? -eq 0 ]; then
            echo ""
            echo "No description for the extension has been supplied!"
            error_out_displaying_usage
        else
            ext_description=$global_arg_value
        fi

        # optional params, if they exist then set them
        check_for_arg "output"
        if [ $? -eq 1 ]; then
            output_location_dir=`echo "$global_arg_value" | awk '{$1=$1};1'` # hack to remove trailing space
        fi

        check_for_arg "permissions"
        if [ $? -eq 1 ]; then
            ext_permissions=$global_arg_value
        fi

        check_for_arg "permissions"
        if [ $? -eq 1 ]; then
            ext_permissions=$global_arg_value
        fi

        check_for_arg "gitinit"
        if [ $? -eq 1 ]; then
            git_init=true
        fi

        check_for_arg "commitmsg"
        if [ $? -eq 1 ]; then
            git_commit_msg=$global_arg_value
        fi
    else 
        error_out_displaying_usage
    fi

    folder_name=$(echo $(echo "${ext_name}" | tr "[:upper:]" "[:lower:]") | tr "[ ]" "[_]")
    full_path_to_package="${output_location_dir}/${folder_name}"
}

check_for_arg() {
    arg_to_check=$1
    for i in "${passed_in_args[@]}"
    do
        temp_index_name=`echo "${i}" | cut -d "=" -f 1`
        if [[ $temp_index_name == $arg_to_check ]]; then
            global_arg_value=`echo "${i}" | cut -d "=" -f 2`
            if [[ $global_arg_value == "" ]] || [[ $global_arg_value == $arg_to_check ]]; then
                return 0
            else
                return 1
            fi
        fi
    done

    return 0
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
    if [ -d "${full_path_to_package}" ]; then
        echo "Folder to create the package in already exists, exiting..."
        echo ""
        exit 1
    fi

    mkdir -p $full_path_to_package
    if [ $? -gt 0 ]; then
        echo ""
        echo "Failed to make directory, exiting..."
        echo ""
        exit 1
    fi

    cp -R "`pwd`/base_template/" $full_path_to_package
    if [ $? -gt 0 ]; then
        echo ""
        echo "Failed to copy templating files, exiting..."
        echo ""
        exit 1
    fi
    
    find ${full_path_to_package} -type f -exec sed -i '' "s/%%TEMPLATE_NAME%%/${ext_name}/g" {} +
    find ${full_path_to_package} -type f -exec sed -i '' "s/%%TEMPLATE_SHORT_NAME%%/${ext_short_name}/g" {} +
    find ${full_path_to_package} -type f -exec sed -i '' "s/%%TEMPLATE_AUTHOR%%/${ext_author}/g" {} +
    find ${full_path_to_package} -type f -exec sed -i '' "s/%%TEMPLATE_DESCRIPTION%%/${ext_description}/g" {} +
    find ${full_path_to_package} -type f -exec sed -i '' "s/%%TEMPLATE_PERMISSIONS%%/${ext_permissions}/g" {} +

    if [[ $git_init == "true" ]]; then
        echo "--> Setting up git repo..."
        current_dir=`pwd`
        cd ${full_path_to_package} && git init && git add .

        echo "--> Files added and staged..."
        git status

        echo "--> Adding in inital commit..."
        git commit -m "${git_commit_msg}"

        cd ${current_dir}
    fi
}

echo ""
echo "Running template-r..."
handle_input "$@"
echo_out_variables
create_package
echo_out_final_output
echo ""
