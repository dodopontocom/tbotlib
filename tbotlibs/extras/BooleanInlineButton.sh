#!/usr/bin/env bash

_FALSE="⛔"
_TRUE="✅"
_COMMAND="${1:-test}"

#======================== Comment one or another to see the diferrence ================
#_OPTIONS=(${_FALSE} ${_TRUE})
_OPTIONS=("it's OFF" "it's ON")
#======================================================================================

BooleanInlineButton.init() {
	local button1 keyboard title _options true_value false_value button_name
    
    _options=$(getopt --options "" --longoptions "true-value:,false-value:,button-name:" -- "$@")
    eval set -- "${_options}"
    
    while [ "${1}" != "" ] ; do
            case "$1" in
                    --true-value) true_value="$2"; shift 2; echo $1 ;;
                    --false-value) false_value="$2"; shift 2; echo $1 ;;
                    --button-name) button_name="$2"; shift 2 ;;
                    --) echo $1; shift 1; echo $1; ;;
                    *) BooleanInlineButton.usage; break ;;
            esac
    done
    
	title="*Switch:*"

	button1=''

	ShellBot.InlineKeyboardButton --button 'button1' \
		--text "${false_value}" \
		--callback_data "tick_to_true.${button_name}" \
		--line 1
	
	keyboard="$(ShellBot.InlineKeyboardMarkup -b 'button1')"

	ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e ${title})" \
				--parse_mode markdown \
                --reply_markup "$keyboard"
    callback_query_message_reply_markup_inline_keyboard_callback_data[$id]="tick_to_true.${button_name}"
    echo "=-=-=- from init ${callback_query_message_reply_markup_inline_keyboard_callback_data[$id]}"    
}

tick_to_one.bool_button() {
	local button2 keyboard2 name

    name=$1
	button2=''
	
	ShellBot.InlineKeyboardButton --button 'button2' \
		--text "${_OPTIONS[1]}" \
		--callback_data "tick_to_zero.${name}" \
		--line 1

	keyboard2="$(ShellBot.InlineKeyboardMarkup -b 'button2')"

	ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "turning it on..."

    ShellBot.editMessageReplyMarkup --chat_id ${callback_query_message_chat_id[$id]} \
				--message_id ${callback_query_message_message_id[$id]} \
                            	--reply_markup "$keyboard2"
    echo "=-=-=- from false ${callback_query_message_reply_markup_inline_keyboard_callback_data[$id]}"    
}

tick_to_zero.bool_button() {
    local button3 keyboard3 name

    name=$1
    button3=''

	ShellBot.InlineKeyboardButton --button 'button3' \
		--text "${_OPTIONS[0]}" \
		--callback_data "tick_to_one.${name}" \
		--line 1

    keyboard3="$(ShellBot.InlineKeyboardMarkup -b 'button3')"

    ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "turning it off..."

    ShellBot.editMessageReplyMarkup --chat_id ${callback_query_message_chat_id[$id]} \
                                --message_id ${callback_query_message_message_id[$id]} \
                                --reply_markup "$keyboard3"
    echo "=-=-=- from true ${callback_query_message_reply_markup_inline_keyboard_callback_data[$id]}"    
}

BooleanInlineButton.usage() {
    echo.PRETTY "BooleanInlineButton enables a boolean inline button"
    echo.PRETTY "usage: BooleanInlineButton.init --true-value \"<A string representing TRUE value eg.: ON>\" --false-value \"<false string representation>\""
    echo.PRETTY "options: '--true-value' '--false-value' ~> (required)"
}