set -e
clear
echo "=============================="
echo "ᴍɪɴᴀᴄᴛʏʟ ɪɴꜱᴛᴀʟʟᴀᴛɪᴏɴ ꜱᴄʀɪᴘᴛ"
echo "=============================="
echo "This script is only made for Ubuntu and Debian"
echo "Using this on other softwares will not work, if this causes any issues, we are not responsible"
echo ===================================================================================================

install_options(){
    echo "Please select your installation option:"
    echo "[1] All in one Minactyl installation (including settings, reverseproxy, etc.)"
    echo "[2] Download the dependencies for Minactyl."
    echo "[3] Install Minactyl files"
    echo "[4] Configure Minactyl Settings"
    echo "[5] Configure Nginx reverse proxy"
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
        * ) output "You did not enter a valid selection."
            install_options
    esac
}

dependercy_install() {
    echo "======================================================"
    echo "installing dependencies for Minactyl......."
    echo "======================================================"
    sudo apt update
    sudo apt upgrade
    sudo apt-get install nodejs
    sudo apt install npm
    sudo apt-get install git
    echo "======================================================"
    echo "Dependecies installed!"
    echo "======================================================"
}
file_install() {
    echo "======================================================"
    echo "Downloading Minactyl files........"
    echo "======================================================"
    cd /var/www/
    sudo git clone https://github.com/MBG1337/Minactyl/
    cd Minactyl
    sudo npm install
    sudo npm install forever -g
    echo "======================================================"
    echo "Files for Minactyl Sucessfully downloaded!"
    echo "======================================================"
}
settings_configuration() {
    echo "======================================================"
    echo "Launching settings configuration setup."
    echo "Read the documents for more information"
    echo "======================================================"
    cd /var/www/Minactyl/
    file=settings.json

    echo "What is the web port? [80] (This is the port Minactyl will run on)"
    read WEBPORT
    echo "What is the web secret? (This will be used for logins)"
    read WEB_SECRET
    echo "What is the pterodactyl domain? [panel.yourdomain.com]"
    read PTERODACTYL_DOMAIN
    echo "What is the pterodactyl key?"
    read PTERODACTYL_KEY
    echo "What is the Discord Oauth2 ID?"
    read DOAUTH_ID
    echo "What is the Discord Oauth2 Secret?"
    read DOAUTH_SECRET
    echo "What is the Discord Oauth2 Link?"
    read DOAUTH_LINK
    echo "What is the Callback path? [callback]" 
    read DOAUTH_CALLBACKPATH
    echo "Prompt [TRUE/FALSE] (When set to true users wont have to relogin after a session)"
    read DOAUTH_PROMPT
    echo "Hosting Owner's Name? [Your Name]" 
    read COMPANY_OWNER
    echo "Hosting  Name? [Hostings Name]" 
    read COMPANY_NAME
    sed -i -e 's/"port":.*/"port": '$WEBPORT',/' -e 's/"secret":.*/"secret": "'$WEB_SECRET'"/' -e 's/"domain":.*/"domain": "'$PTERODACTYL_DOMAIN'",/' -e 's/"key":.*/"key": "'$PTERODACTYL_KEY'"/' -e 's/"id":.*/"id": "'$DOAUTH_ID'",/' -e 's/"link":.*/"link": "'$DOAUTH_LINK'",/' -e 's/"path":.*/"path": "'$DOAUTH_CALLBACKPATH'",/' -e 's/"prompt":.*/"prompt": '$DOAUTH_PROMPT'/' -e '0,/"secret":.*/! {0,/"secret":.*/ s/"secret":.*/"secret": "'$DOAUTH_SECRET'",/} -e 's/"companyowner":.*/"companyowner": "'$COMPANY_OWNER'"/'' -e 's/"companyname":.*/"companyname": "'$COMPANY_NAME'"/' $file
    echo "-------------------------------------------------------"
    echo "Main Configuration Settings Completed!"
    echo "Some Configuration need to setup manually"
}
reverseproxy_configuration() {
    echo "-------------------------------------------------------"
    echo "Starting Reverse Proxy Configuration."
    echo "This is going to forward your.client.domain:port to your.client.domain "
    echo "https://josh0086.gitbook.io/dashactyl/"
    echo "-------------------------------------------------------"

   echo "Select your webserver [NGINX]"
   read WEBSERVER
   echo "Protocol Type [HTTP]"
   read PROTOCOL
   if [ $PROTOCOL != "HTTP" ]; then
   echo "------------------------------------------------------"
   echo "HTTP is currently only supported on the install script."
   echo "------------------------------------------------------"
   return
   fi
   if [ $WEBSERVER != "NGINX" ]; then
   echo "------------------------------------------------------"
   echo "Aborted, only Nginx is currently supported for the reverse proxy."
   echo "------------------------------------------------------"
   return
   fi
   echo "What is your domain? [example.com]"
   read DOMAIN
   apt install nginx
   sudo wget -O /etc/nginx/conf.d/Minactyl.conf https://raw.githubusercontent.com/Minactyl/Minactyl-installer/main/NginxHTTPReverseProxy.conf
   sudo apt-get install jq 
   port=$(jq -r '.["website"]["port"]' /var/www/Minactyl/settings.json)
   sed -i 's/PORT/'$port'/g' /etc/nginx/conf.d/Minactyl.conf
   sed -i 's/DOMAIN/'$DOMAIN'/g' /etc/nginx/conf.Minactyl.conf
   sudo nginx -t
   sudo nginx -s reload
   systemctl restart nginx
   echo "-------------------------------------------------------"
   echo "Reverse Proxy Install and configuration completed."
   echo "-------------------------------------------------------"
   echo "Here is the config status:"
   sudo nginx -t
   echo "-------------------------------------------------------"
   echo "Note: if it does not say OK in the line, an error has occurred and you should try again or get help in the Minactyl Discord Server."
   echo "-------------------------------------------------------"
   if [ $WEBSERVER = "APACHE" ]; then
   echo "Apache isn't currently supported with the install script."
   echo "------------------------------------------------------"
   return
   fi
}
update_check() {
    latest=$(wget https://raw.githubusercontent.com/Minactyl/Minactyl-installer/main/version.json -q -O -)
    #latest='"version": "0.1.2-themes6",'
    version=$(grep -Po '"version":.*?[^\\]",' /var/www/Minactyl/settings.json) 

    if [ "$latest" =  "$version" ]; then
    echo "======================================================"
    echo "You're running the latest version of Minactyl."
    echo "======================================================"
    else 
    echo "======================================================"
    echo "You're running an outdated version of Minactyl."
    echo "======================================================"
    echo "Would you like to update to the latest version? [Y/N]"
    echo "Bu updating your files will be backed up in /var/www/Minactyl-backup/"
    read UPDATE_OPTION
    echo "-------------------------------------------------------"
    if [ "$UPDATE_OPTION" = "Y" ]; then
    var=`date +"%FORMAT_STRING"`
    now=`date +"%m_%d_%Y"`
    now=`date +"%Y-%m-%d"`
    if [[ ! -e /var/www/Minactyl-backup/ ]]; then
    mkdir /var/www/Minactyl-backup/
    finish_update
    elif [[ ! -d $dir ]]; then
    finish_update
    fi
    else
    echo "Update Aborted"
    echo "Restart the script if this was a mistake."
    echo "-------------------------------------------------------"
    fi
    fi
}
finish_update() {
   tar -czvf "${now}.tar.gz" /var/www/Minactyl/
   mv "${now}.tar.gz" /var/www/Minactyl-backup
   rm -R /var/www/Minactyl/
   file_install
}
install_options
