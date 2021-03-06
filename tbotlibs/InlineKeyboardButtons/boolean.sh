#!/usr/bin/env bash

_FALSE="⛔"
_TRUE="✅"
_COMMAND="${1:-test}"

#======================== Comment one or another to see the diferrence ================
#_OPTIONS=(${_FALSE} ${_TRUE})
_OPTIONS=("it's OFF" "it's ON")
#======================================================================================

init.bool_button() {
	local button1 keyboard title name
    name=$1
	title="*Switch:*"

	button1=''

	ShellBot.InlineKeyboardButton --button 'button1' \
		--text "${_OPTIONS[0]}" \
		--callback_data "tick_to_one.${name}" \
		--line 1
	
	keyboard="$(ShellBot.InlineKeyboardMarkup -b 'button1')"

	ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e ${title})" \
				--parse_mode markdown \
                --reply_markup "$keyboard"
    callback_query_message_reply_markup_inline_keyboard_callback_data[$id]="tick_to_one.${name}"
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