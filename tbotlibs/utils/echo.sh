#!/usr/bin/env bash

echo.SUCCESS() {
    local message=$1
    echo -e "[SUCCESS] ${message}"
}
echo.INFO() {
    local message=$1
    echo -e "[INFO] ${message}"
}
echo.ERROR() {
    local message=$1
    echo -e "[ERROR] ${message}"
}
echo.WARN() {
    local message=$1
    echo -e "[WARN] ${message}"
}
echo.PRETTY() {
    echo
    _echo 1 "" "\e[1m       ${@}"
    echo
}
_echo() {

    local _stdRedirect="${1}"; shift
    local _textToPrint="${1}"; shift
    local _text="${@/'\n'/$'\n'}"

    # For each line
    local IFS=$'\n'
    for _line in ${_text[@]}; do
        echo -e "${_textToPrint} ${_line}" >&"${_stdRedirect}"
        _textToPrint="   "
    done
}