#!/bin/bash
set -e
clear
echo "====================="
echo "Minactyl Installer"
echo "====================="
echo "Note that this installer"
echo "Is just for Ubuntu/Debian"
echo "========================================"

install_options(){
    echo "Please select your installation option:"
    echo "[1] Full Fresh Minactyl Install (Dependencies, Files, Configuration)"
    echo "[2] Install the Dependencies."
    echo "[3] Install the Files."
    echo "[4] Configure Settings."
    echo "[5] Create and configure a reverse proxy."
    echo "========================================"
    read choice
    case $choice in
        1 ) installoption=1
            dependercy_install
            file_install
            settings_configuration
            reverseproxy_configuration
            ;;
        2 ) installoption=2
            dependercy_install
            ;;
        3 ) installoption=3
            file_install
            ;;
        4 ) installoption=4
            settings_configuration
            ;;
        5 ) installoption=5
            reverseproxy_configuration
            ;;
        6 ) installoption=6
            update_check
            ;;
        * ) echo "You did not enter a valid selection."
            install_options
    esac
}

dependercy_install() {
    echo "======================================================"
    echo "Starting Dependency install."
    echo "======================================================"
    sudo apt update
    sudo apt upgrade -y
    sudo apt-get install -y nodejs
    sudo apt install -y npm
    sudo apt-get install -y git
    echo "======================================================"
    echo "Dependency Install Completed!"
    echo "======================================================"
}

file_install() {
    echo "======================================================"
    echo "Starting File download."
    echo "======================================================"
    cd /var/www/ || exit
    sudo git clone https://github.com/MBG1337/Minactyl/
    cd Minactyl || exit
    sudo npm install
    sudo npm install forever -g
    echo "======================================================"
    echo "Minactyl File Download Completed!"
    echo "======================================================"
}

settings_configuration() {
    echo "======================================================"
    echo "Starting Settings Configuration."
    echo "Read the Docs for more information about the settings."
    echo "soon"
    echo "======================================================"
    cd /var/www/Minactyl/ || exit
    file=settings.json

    echo "What is the web port? [80] (This is the port Minactyl will run on)"
    read -r WEBPORT
    echo "What is the web secret? (This will be used for logins)"
    read -r WEB_SECRET
    echo "What is the Pterodactyl domain? [panel.yourdomain.com]"
    read -r PTERODACTYL_DOMAIN
    echo "What is the Pterodactyl key?"
    read -r PTERODACTYL_KEY
    echo "What is the Discord OAuth2 ID?"
    read -r DOAUTH_ID
    echo "What is the Discord OAuth2 Secret?"
    read -r DOAUTH_SECRET
    echo "What is the Discord OAuth2 Link?"
    read -r DOAUTH_LINK
    echo "What is the Callback path? [callback]" 
    read -r DOAUTH_CALLBACKPATH
    echo "Prompt [TRUE/FALSE] (When set to true users won't have to re-login after a session)"
    read -r DOAUTH_PROMPT
    echo "What is the Company Name?" 
    read -r COMPANY_NAME
    sed -i
