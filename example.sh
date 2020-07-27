#!/bin/bash
#
export BASEDIR="$(cd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1 && pwd)"

#DO NOT COMMIT THIS TOKEN TO GIT
export TELEGRAM_TOKEN="<your_telegram_bot_token>"
# export TELEGRAM_TOKEN="$(head -1 .definitions.sh)"

source ${BASEDIR}/tbotlib.sh

while : ; do
        ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
            
        for id in $(ShellBot.ListUpdates); do
            (
            ShellBot.watchHandle --callback_data ${callback_query_data[$id]}

            if [[ ${message_entities_type[$id]} == bot_command ]]; then
                case ${message_text[$id]%%@*} in
                    /start)
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "🤖 Bot ao seu dispor ☝️" ;;
                    /switch)
                        init.bool_button --options on off --name switch
                esac
            fi

            case ${callback_query_data[$id]} in
                tick_to_one.switch) tick_to_one.bool_button ;;
                tick_to_zero.switch) tick_to_zero.bool_button ;;
            esac

            ) &
        done
done
