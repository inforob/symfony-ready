#!/bin/bash

add_host() {
  sudo sed -i '1s/^/174.16.4.1       '${APP}'\n/' /etc/hosts
}

remove_host(){
  sudo sed -i '/'${APP}'/d' /etc/hosts
}

log_error(){
   local MSG="$1"
   printf "%s - [ERROR] %s\n" "$(date)" "$MSG" >&2
}

case "$1" in
    "") ;;
    add_host) "$@"; exit;;
    remove_host) "$@"; exit;;
    *) log_error "Unkown function: $1()"; exit;;
esac