#!/usr/bin/env bash

WelcomeMessage.send() {

    local message user_message short options

    options=$(getopt --options "" --longoptions "message:,short" -- "$@")
    eval set -- "${options}"
    
    while true ; do
            case "$1" in
                    --message) user_message="$2"; shift 2 ;;
                    --short) short="on"; shift ;;
                    --) shift ;;
                    *) WelcomeMessage.usage; break ;;
            esac
    done

    if [[ ${user_message} ]] && [[ ${message_new_chat_member_id[$id]} ]]; then
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
    elif [[ ! ${message_new_chat_member_id[$id]} ]]; then
        echo.WARN "Welcome message only works when 'message_new_chat_member_id' variable exists."
    elif [[ ! ${user_message} ]] && [[ ${short} ]]; then
        echo.WARN "'short' option still requires 'message'. Please provide 'message' (--short --message \"your short message\")"
    fi
    
    return 0
}

WelcomeMessage.usage() {
    echo.PRETTY "WelcomeMessage sends a message to new member of a group"
    echo.PRETTY "usage: WelcomeMessage.send --message \"<YOUR WELCOME MESSAGE>\""
    echo.PRETTY "option: '--message' \"<your welcome message>\" ~> (required)"
    echo.PRETTY "option: '--short' ~> when you want to avoid standard message header (optional)"
}