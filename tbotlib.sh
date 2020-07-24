#!/bin/bash

#VERSION:   build-v0.1

export API_GIT_URL="https://github.com/shellscriptx/shellbot.git"
export API_VERSION_RAW_URL="https://raw.githubusercontent.com/shellscriptx/shellbot/master/ShellBot.sh"

LIB_BRANCH="master"
LIB_REPO="https://github.com/dodopontocom/tbotlib.git"
LIB_RAW_URL="https://raw.githubusercontent.com/dodopontocom/tbotlib/master/tbotlib.sh"
LIBS_FOLDER="${BASEDIR}/tbotlibs/"
tmp_folder=$(mktemp -d)

check_new_version=$(curl -sS ${LIB_RAW_URL} | grep -m1 VERSION | cut -d':' -f2)
current_version=$(cat ${BASEDIR}/tbotlib.sh | grep -m1 VERSION | cut -d':' -f2)
if [[ "${current_version}" != "${check_new_version}" ]]; then
    echo "[WARN] tbotlib is out of date, we recomend to get new version."
    echo "[INFO] tbotlib script: ${LIB_RAW_URL}"
else
    echo "[INFO] tbotlib is up to date!"
fi

if [[ ! -d ${BASEDIR}/tbotlibs ]]; then
    git clone --quiet --single-branch --branch ${LIB_BRANCH} ${LIB_REPO} ${tmp_folder} > /dev/null
    cp -r ${tmp_folder}/tbotlibs ${LIBS_FOLDER}
    rm -fr ${tmp_folder}    
fi

[[ $(cat ${BASEDIR}/.gitignore | grep tbotlibs) ]] || \
    echo -e "\n\n#Telegram bot Libs\ntbotlibs" >> ${BASEDIR}/.gitignore

libs_list=($(find ${BASEDIR}/tbotlibs -name "*.sh"))
for f in ${libs_list[@]}; do
    source ${f}
    echo "[INFO] Library '$(basename ${f%%.*})' is now loaded. ($(cat ${f} | grep "() {$" | wc -l)) functions you can use from."
done

helper.get_api
exitOnError "Error while trying to download API Shellbot" $?
helper.validate_vars TELEGRAM_TOKEN
exitOnError "You must configure and export 'TELEGRAM_TOKEN' variable" $?

source ${BASEDIR}/tbotlibs/ShellBot.sh

echo.SUCCESS "Telegram bot lib is successfully loaded"