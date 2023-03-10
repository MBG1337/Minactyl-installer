#!/bin/bash

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "\e[31mThis script must be run as root.\e[0m"
   exit 1
fi

# Print output messages
output() {
    echo -e "\e[32m$1\e[0m"
}

# Exit on error
set -e

clear
output "====================="
output "Minactyl Installer"
output "====================="
output "Note that this install"
output "Is just for Ubuntu/Debian"
output "========================================"

# Update package lists
output "Updating package lists..."
apt-get update

# Upgrade packages
output "Upgrading packages..."
apt-get upgrade -y

install_options() {
    output "Please select your installation option:"
    output "[1] Full Fresh Minactyl Install (Dependencies, Files, Configuration)"
    output "[2] Install the Dependencies."
    output "[3] Install the Files."
    output "[4] Configure Settings."
    output "[5] Create and configure a reverse proxy."
    output "========================================"
    read choice
    case $choice in
        1)
            installoption=1
            dependercy_install
            file_install
            settings_configuration
            reverseproxy_configuration
            ;;
        2)
            installoption=2
            dependercy_install
            ;;
        3)
            installoption=3
            file_install
            ;;
        4)
            installoption=4
            settings_configuration
            ;;
        5)
            installoption=5
            reverseproxy_configuration
            ;;
        6)
            installoption=6
            update_check
            ;;
        *)
            output "You did not enter a valid selection."
            install_options
            ;;
    esac
}

dependercy_install() {
    output "======================================================"
    output "Starting Dependency install."
    output "======================================================"
    # Install dependencies
    apt-get install -y nodejs npm git

    output "======================================================"
    output "Dependency Install Completed!"
    output "======================================================"
}

file_install() {
    output "======================================================"
    output "Starting File download."
    output "======================================================"
    cd /var/www/
    # Clone Minactyl repository
    git clone https://github.com/MBG1337/Minactyl/
    cd Minactyl
    npm install
    npm install forever -g

    output "======================================================"
    output "Minactyl File Download Completed!"
    output "======================================================"
}

settings_configuration() {
    output "======================================================"
    output "Starting Settings Configuration."
    output "Read the Docs for more information about the settings."
    output "soon"
    output "======================================================"
    cd /var/www/Minactyl/
