#!/bin/bash
alias lt='ls --human-readable --size -1 -S --classify'
alias nodelts='nvm install "lts/*" --reinstall-packages-from=current --latest-npm'
alias npmlts='nvm install-latest-npm'
alias gbh='history|grep'
alias wwi='ls -t -1'
alias count='find . -type f | wc -l'
alias pyenv='python3 -m venv ./venv'
alias pyenvrun='source ./venv/bin/activate'
alias cpv='rsync -ah --info=progress2'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias kill5000='sudo kill -9 $(lsof -t -i:5000 -sTCP:LISTEN)'
alias kill3000='sudo kill -9 $(lsof -t -i:3000 -sTCP:LISTEN)'
alias kill8000='sudo kill -9 $(lsof -t -i:8000 -sTCP:LISTEN)'
alias kill8080='sudo kill -9 $(lsof -t -i:8080 -sTCP:LISTEN)'
alias aptall='sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y'
alias pushenv='npx dotenv-vault@latest push'
alias pullenv='npx dotenv-vault@latest pull'
alias servstat='sudo service --status-all'
alias fixtime='sudo hwclock -s'
alias dotfix='dotenv-linter fix'
alias pidmagic='sudo ps axjf'
alias sysstat='systemctl list-unit-files --type=service'
