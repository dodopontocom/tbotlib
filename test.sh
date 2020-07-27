#!/usr/bin/env bash

while $1 ; do
	case "${1}" in
		"--message") message=${2}; echo $message; shift 2 ;;
		"--short") short="on"; shift 1 ;;
		*) echo ruim ;;
	esac
done
