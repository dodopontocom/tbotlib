#!/usr/bin/env bash

WelcomeMessage.send() {
	local message

    if [[ ${message_new_chat_member_id[$id]} ]]; then
        message="🆔 [@${message_new_chat_member_username[$id]:-null}]\n"
        message+="🗣 Olá \*${message_new_chat_member_first_name[$id]}\*"'!!\n\n'
        message+="Seja bem-vindo(a) ao \*${message_chat_title[$id]}\*.\n\n"
        message+="\`$1\`"

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
    echo.PRETTY "usage: WelcomeMessage.send \"<YOUR WELCOME MESSAGE>\""

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