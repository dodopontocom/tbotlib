#!/bin/bash

#VERSION:build-v0.1-alpha

export API_GIT_URL="https://github.com/shellscriptx/shellbot.git"
export API_VERSION_RAW_URL="https://raw.githubusercontent.com/shellscriptx/shellbot/master/ShellBot.sh"

LIB_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") >/dev/null 2>&1 && pwd)
LIB_BRANCH="develop"
LIB_REPO="https://github.com/dodopontocom/tbotlib.git"
LIB_RAW_URL="https://raw.githubusercontent.com/dodopontocom/tbotlib/${LIB_BRANCH}/tbotlib.sh"
LIBS_FOLDER="${LIB_DIR}/tbotlibs/"
tmp_folder=$(mktemp -d)

check_new_version=$(curl -sS ${LIB_RAW_URL} | grep -m1 VERSION | cut -d':' -f2)
current_version=$(cat ${LIB_DIR}/tbotlib.sh | grep -m1 VERSION | cut -d':' -f2)
echo "[INFO] getting tbotlib from original branch: '${LIB_BRANCH}'"
echo "[INFO] tbotlib version: '${current_version}'"
if [[ "${current_version}" != "${check_new_version}" ]]; then
    echo "[WARN] new version is available (version: '${check_new_version}')"
    echo "[INFO] get new version (script: ${LIB_RAW_URL})"
else
    echo "[INFO] tbotlib is up to date!"
fi

if [[ ! -d ${LIB_DIR}/tbotlibs ]] && \
        [[ "$(git config --get remote.origin.url)" != "${LIB_REPO}" ]]; then
    git clone --quiet --single-branch --branch ${LIB_BRANCH} ${LIB_REPO} ${tmp_folder} > /dev/null
    cp -r ${tmp_folder}/tbotlibs ${LIBS_FOLDER}
    rm -fr ${tmp_folder}    
fi

if [[ ! $(cat ${LIB_DIR}/.gitignore | grep tbotlibs) ]] && \
        [[ "$(git config --get remote.origin.url)" != "${LIB_REPO}" ]]; then
    echo -e "\n\n#Telegram bot Libs\ntbotlibs\n-" >> ${LIB_DIR}/.gitignore
fi

funcCount() { cat ${1} | grep "() {$" | wc -l; }

libs_list=($(find ${LIB_DIR}/tbotlibs -name "*.sh"))
for f in ${libs_list[@]}; do
    source ${f}
    echo "[INFO] Library '$(basename ${f%%.*})' is now loaded. ($(funcCount ${f})) functions you can use from."
done

helper.get_api
exitOnError "Error while trying to download API Shellbot" $?
helper.validate_vars TELEGRAM_TOKEN
exitOnError "You must configure and export 'TELEGRAM_TOKEN' variable" $?

source ${LIB_DIR}/tbotlibs/API/ShellBot.sh
ShellBot.init --token "${TELEGRAM_TOKEN}" --monitor --flush
echo.SUCCESS "Telegram bot lib is successfully loaded"
