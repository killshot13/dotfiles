#!/bin/bash
# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

## Stop apache2 if running

# status=$(service apache2 status)
# if [[ $status == *"apache2 is running" ]]; then
#  sudo service apache2 stop
# fi

## Stop Mysql if running

# status=$(service mysql status)
# if [[ $status != *"MySQL is stopped." ]]; then
#    sudo service mysql stop
# fi
