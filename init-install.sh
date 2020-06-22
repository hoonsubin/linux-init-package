#!/bin/bash

BASEDIR=$(dirname "$0")

if [[ "$OSTYPE" == "linux-gnu" ]]; then
	set -e
	if [[ $(whoami) == "root" ]]; then
		MAKE_ME_ROOT=
	else
		MAKE_ME_ROOT=sudo
	fi
    # update apt packages
    $MAKE_ME_ROOT apt update && $MAKE_ME_ROOT apt upgrade -y
    
	if cat /etc/*-release | grep "Ubuntu" > /dev/null ; then
		echo "installing for Ubuntu."
        $MAKE_ME_ROOT add-apt-repository universe
        
        # install all the apt packages in the text file
        cat "$BASEDIR/apt-packages.txt" | xargs $MAKE_ME_ROOT apt install -y
    
        # install dev tools from snap
        $MAKE_ME_ROOT snap install chromium
        $MAKE_ME_ROOT snap install pycharm-community --classic
        $MAKE_ME_ROOT snap install postman
        $MAKE_ME_ROOT snap install code --classic

    elif cat /etc/*-release | grep "Kali GNU" > /dev/null ; then
        echo "installing for Kali."

        # install all kali meta packages
        $MAKE_ME_ROOT apt install kali-linux-everything

        # install VS code
        curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        $MAKE_ME_ROOT install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
        $MAKE_ME_ROOT sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
        $MAKE_ME_ROOT apt update
        $MAKE_ME_ROOT apt install code
    else
        echo "This OS is not supported with this script."
        exit 1
    fi

    # install .net core SDK
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    $MAKE_ME_ROOT dpkg -i packages-microsoft-prod.deb
    $MAKE_ME_ROOT apt update; \
    $MAKE_ME_ROOT apt install -y apt-transport-https && \
    $MAKE_ME_ROOT apt update && \
    $MAKE_ME_ROOT apt install -y dotnet-sdk-3.1
    # install yarn
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | $MAKE_ME_ROOT apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | $MAKE_ME_ROOT tee /etc/apt/sources.list.d/yarn.list
    $MAKE_ME_ROOT apt update && $MAKE_ME_ROOT apt install yarn

    # install rust and substrate tools
    curl https://getsubstrate.io -sSf | bash -s --
    source ~/.cargo/env

    # install etcher
    echo "deb https://deb.etcher.io stable etcher" | $MAKE_ME_ROOT tee /etc/apt/sources.list.d/balena-etcher.list
    $MAKE_ME_ROOT apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv-keys 379CE192D401AB61
    $MAKE_ME_ROOT apt update
    $MAKE_ME_ROOT apt install balena-etcher-electron

    # install nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    # This loads nvm
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    nvm install node

    # install VS code extensions from list
    # path to the extension list
    input="$BASEDIR/vscode-extensions.txt"

    # install all the extensions in the txt file
    while IFS= read -r line
    do
        code --install-extension "$line"
    done < "$input"

else
    echo "This OS is not supported with this script."
    exit 1
fi
