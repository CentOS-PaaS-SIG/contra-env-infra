#!/bin/bash


# create shared library configs from project and helper repos
openshift_lib_dir=/opt/openshift/configuration/init.groovy.d/sharedLibConfigs

# $1 - the name of the shared library
# $2 - the repo url
# $3 - the branch to use
create_library_config() {
    local config_name=$(parse_repo $2)
    cat > "${openshift_lib_dir}/${config_name}.json" <<- EOF
{
  "name": "$1",
  "url": "$2",
  "branch": "$3",
  "implicit": true
}
EOF
}

# $1 a repository url
# returns - organization-reponame
parse_repo() {
    local repo_name=$1
    IFS='/' read -ra ADDR <<< "${repo_name}"
    IFS='.' read -ra REPO <<< "${ADDR[4]}"

    echo "${ADDR[3]}-${REPO[0]}"
}

