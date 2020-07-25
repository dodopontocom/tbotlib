#!/bin/bash
#
export BASEDIR="$(cd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1 && pwd)"

#DO NEVER COMMIT THIS TOKEN TO GIT
export TELEGRAM_TOKEN="<your_telegram_bot_token>"

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
                esac
            fi
            ) &
        done
done
