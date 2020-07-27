#!/usr/bin/env bash

WelcomeMessage.send() {
    echo main
}

WelcomeMessage.usage() {
    echo.PRETTY "WelcomeMessage sends a message to new member of a group" \
        "usage: WelcomeMessage.send \"<YOUR WELCOME MESSAGE>\""

    # local param=$(getopt --name "$FUNCNAME" --options 't:mfsu:l:o:r:d:' \
    #     --longoptions 'token:,
    #                 monitor,
    #                 flush,
    #                 service,
    #                 user:,
    #                 log_file:,
    #                 log_format:,
    #                 return:,
    #                 delimiter:' \
    #     -- "$@")
    
    # eval set -- "$param"
}