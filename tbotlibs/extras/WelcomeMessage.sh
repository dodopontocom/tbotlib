#!/usr/bin/env bash

WelcomeMessage.send() {

    local message user_message short
    while [ "${1}" != "" ]; do
        case "${1}" in
            "--message") user_message="${2}"; shift 2 ;;
            "--short") short="on"; shift 1 ;;
            *) WelcomeMessage.usage; exit -1 ;;
        esac
    done

    if [[ ${message_new_chat_member_id[$id]} ]]; then
        if [[ ! ${short} ]]; then
            message="🆔 [@${message_new_chat_member_username[$id]:-null}]\n"
            message+="🗣 Olá *${message_new_chat_member_first_name[$id]}*"'!!\n\n'
            message+="Seja bem-vindo(a) ao *${message_chat_title[$id]}*.\n\n"
            message+="\`${user_message}\`"
        else
            message="\`${user_message}\`"
        fi
        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                                --text "$(echo -e $message)" \
                                --parse_mode markdown
    else
        echo.WARN "Welcome message only works when 'message_new_chat_member_id' variable exists."
    fi
    
    return 0
}

WelcomeMessage.usage() {
    echo.PRETTY "WelcomeMessage sends a message to new member of a group"
    echo.PRETTY "usage: WelcomeMessage.send --message \"<YOUR WELCOME MESSAGE>\""
    echo.PRETTY "option: '--message' \"<your welcome message>\" ~> (required)"
    echo.PRETTY "option: '--short' ~> when you want to avoid standard message header (optional)"

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