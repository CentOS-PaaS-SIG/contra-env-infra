#!/bin/bash

# $1 - path to shared library config
# $2 - the name of the shared library
# $3 - the repo url
# $4 - the branch to use
create_library_config() {
    cat > $1 <<- EOM
    {
      "name": "$2",
      "url": "$3",
      "branch": "$4",
      "implicit": true
    }
EOM
}

# $1 a repository url
# returns - organization-reponame
parse_repo() {
    local repo_name=$1
    IFS='/' read -ra ADDR <<< "${$repo_name}"
    IFS='.' read -ra REPO <<< "${ADDR[4]}"

    echo "${ADDR[3]}-${REPO[0]}"
}


# create shared library configs from project and helper repos
openshift_lib_dir=/opt/openshift/configuration/init.groovy.d/sharedLibConfigs

