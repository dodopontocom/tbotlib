#!/bin/bash
#
export BASEDIR="$(cd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1 && pwd)"
source ${BASEDIR}/.definitions.sh
source ${BASEDIR}/tbotlib.sh

btn_opcoes=''
btn_opcoes='
["Felicidade", "Interesse", "Empolgação"],
["Cuidado", "Afeição", "Amor"],
["Amado", "Compaixão", "Gratidão"],
["Orgulho", "Confiança", "Mágoa"],
["Tristeza", "Arrependimento", "Irritação"],
["Raiva", "Ressentimento", "Nojo"],
["Contentamento", "Vergonha", "Culpa"],
["Inveja", "Ciúme", "Ansiedade"],
["Medo"]
'
keyboard="$(ShellBot.ReplyKeyboardMarkup --button 'btn_opcoes' --one_time_keyboard true)"

_MESSAGE="\`📝 Adicionar Nota:\`"

#e.g. : convert.weekdayPtbr $(date +%u)
convert.weekdayPtbr() {
  local day="$1"
  case ${day} in
      '1' ) echo "Segunda-feira" ;;
      '2' ) echo "Terça-feira" ;;
      '3' ) echo "Quarta-feira" ;;
      '4' ) echo "Quinta-feira" ;;
      '5' ) echo "Sexta-feira" ;;
      '6' ) echo "Sábado" ;;
      '7' ) echo "Domingo" ;;
      * ) echo "Error" ;;
  esac
}

nota.start() {

    local emocao
    emocao="${message_text[$id]}"

    echo "${emocao}" > /tmp/${message_from_id[$id]//-/}

    [[ ${message_reply_to_message_chat_id[$id]} ]] && \
        ShellBot.deleteMessage --chat_id ${message_reply_to_message_chat_id[$id]} --message_id ${message_reply_to_message_message_id[$id]}
    [[ ${message_chat_id[$id]} ]] && \
        ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}

    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                        --text "$(echo -e ${_MESSAGE})" \
                        --parse_mode markdown \
        				--reply_markup "$(ShellBot.ForceReply)"
}

nota.done() {
    local nota folder _save name _day
    nota="${1}"
    _day="$(convert.weekdayPtbr $(date +%u))"
    folder="${message_from_id[$id]//-/}"
    _save="${BOT_EMOCOES_FILE}/${folder}/_list.log"

    if [[ ${message_chat_first_name[$id]} ]]; then
        name="${message_chat_first_name[$id]}"
    else
        name="${message_from_first_name[$id]}"
    fi        
    if [[ ! -f "${_save}" ]]; then
        mkdir -p ${_save%%_*}
    fi

    echo "$(date +%d/%m/%Y)|$(date +%H:%M)|$(head -1 /tmp/${folder})|${_day}|${name}|${nota}" >> ${_save}

    [[ ${message_reply_to_message_chat_id[$id]} ]] && \
        ShellBot.deleteMessage --chat_id ${message_reply_to_message_chat_id[$id]} --message_id ${message_reply_to_message_message_id[$id]}
    [[ ${message_chat_id[$id]} ]] && \
        ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}

    message="*$(tail -1 ${_save} | cut -d'|' -f4) ($(tail -1 ${_save} | cut -d'|' -f1)) - $(tail -1 ${_save} | cut -d'|' -f2)hs*\n"
    message+="*autor:* ($(tail -1 ${_save} | cut -d'|' -f5))\n"
    message+="*emoção:* ($(tail -1 ${_save} | cut -d'|' -f3))\n"
    message+="*nota:* \`$(tail -1 ${_save} | cut -d'|' -f6)\`"

    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                        --text "$(echo -e ${message})" \
                        --parse_mode markdown
}

while : ; do
        ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
            
        for id in $(ShellBot.ListUpdates); do
            (

            ShellBot.watchHandle --callback_data ${callback_query_data[$id]}

            if [[ ${message_entities_type[$id]} == bot_command ]]; then
                case ${message_text[$id]%%@*} in
                    /start)
                        message="🤖 Bot ao seu dispor ☝️\n"
                        message+="Aperte aqui para começar \`/diario\`"
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
                    ;; 
                    /diario)
                        echo ${message_from_is_bot}
                        ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
                                            --text "*Escolha as Emoções abaixo*" \
                                            --parse_mode markdown \
                                            --reply_markup "$keyboard"
                    ;;
                esac
            fi

            if [[ ${message_text[$id]} ]] \
                    && [[ ! ${message_entities_type[$id]} ]] \
                    && [[ ! ${message_reply_to_message_chat_id} ]]; then
                while read line; do
                    if [[ ${message_text[$id]} == ${line} ]]; then
                        case ${message_text[$id]} in
                            ${line}) nota.start ;;
                        esac
                    fi
                done < ${BASEDIR}/emocoes.txt
            fi

            if [[ ${message_reply_to_message_message_id[$id]} ]]; then
                case ${message_reply_to_message_text[$id]} in
                    '📝 Adicionar Nota:') nota.done "${message_text[$id]}" ;;
                    'Escolha as Emoções abaixo')
                        while read line; do
                            if [[ ${message_text[$id]} == ${line} ]]; then
                                case ${message_text[$id]} in
                                    ${line}) nota.start ;;
                                esac
                            fi
                        done < ${BASEDIR}/emocoes.txt
                    ;;
                esac
            fi

            ) &
        done
done
