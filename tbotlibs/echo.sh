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