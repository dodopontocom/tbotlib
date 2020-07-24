#!/usr/bin/env bash

_FALSE="⛔"
_TRUE="✅"
_COMMAND="${1:-test}"

#======================== Comment one or another to see the diferrence ================
#_OPTIONS=(${_FALSE} ${_TRUE})
_OPTIONS=("it's ON" "it's OFF")
#======================================================================================

tick_to_false.bool_button() {
	local button2 keyboard2

	button2=''
	
	ShellBot.InlineKeyboardButton --button 'button2' \
		--text "${_OPTIONS[1]}" \
		--callback_data "tick_to_true_bool_button" \
		--line 1

	keyboard2="$(ShellBot.InlineKeyboardMarkup -b 'button2')"

	ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "turning it true..."

    ShellBot.editMessageReplyMarkup --chat_id ${callback_query_message_chat_id[$id]} \
				--message_id ${callback_query_message_message_id[$id]} \
                            	--reply_markup "$keyboard2"
}

tick_to_true.bool_button() {
    local button3 keyboard3

    button3=''

	ShellBot.InlineKeyboardButton --button 'button3' \
		--text "${_OPTIONS[0]}" \
		--callback_data "tick_to_false_bool_button" \
		--line 1

    keyboard3="$(ShellBot.InlineKeyboardMarkup -b 'button3')"

    ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "turning it false..."

    ShellBot.editMessageReplyMarkup --chat_id ${callback_query_message_chat_id[$id]} \
                                --message_id ${callback_query_message_message_id[$id]} \
                                --reply_markup "$keyboard3"
}