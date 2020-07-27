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
    local _text="${@/'\n'/$'\n'}"
    echo
    for i in ${@}; do
        echo "\e[1m       ${i}"
    done
    echo
}