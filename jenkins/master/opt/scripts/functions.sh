#!/bin/bash


# create shared library configs from project and helper repos
openshift_lib_dir=opt/openshift/configuration/init.groovy.d/sharedLibConfigs

# $1 - the repo url
# $2 - the branch to use
create_library_config() {
    local config_name=$(parse_repo $1)
    local repo_name="$(cut -d'-' -f2 <<<${config_name})"
    cat > "${openshift_lib_dir}/${config_name}.json" <<- EOF
{
  "name": "$repo_name",
  "url": "$1",
  "branch": "$2",
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

