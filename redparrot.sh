#!/bin/bash

# Error handling for the script
set -e
trap 'error_handling' EXIT
error_handling() {
    exit_status=$?
    error_message=$(cat logs/errors.log)
    if [ "$exit_status" -ne 0 ]; then
        printf "\r"
        print_error "$error_message"
        clean_up_tmp
    fi
}

# Vars
target_user=$(ls /home)

# Setting colors for text format
BLUE=$(tput setaf 14)
GREEN=$(tput setaf 10)
RED=$(tput setaf 9)
PURPLE=$(tput setaf 13)
ENDCOLOR=$(tput sgr0)

# Print banner
 banner () {
    echo "$RED⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣶⡾⠤⠤⠤⠤⠄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠋⡡⠖⠒⠒⢄⣤⠒⠛⠳⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠁⡸⠀⣠⡀⢀⠀⡇⠀⠀⠀⠀⠙⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡏⠀⢧⡀⣯⣿⣿⡄⣇⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⠀⠀⢹⠈⠙⠁⢠⣾⣿⣷⣦⡀⠀⢸⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⡀⢀⠣⣄⣀⡀⠝⢿⣿⠿⢣⡠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡰⠃⢠⣽⠶⢤⠀⣀⡀⢿⣄⠀⠀⠀⠀⣠⠴⣶⣤⣀⣠⣤⣖⣒⡀⢀⡠⠂
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡔⠉⠀⠐⠉⢀⠀⠀⡇⠁⠀⠀⠙⣗⠒⣒⡭⠴⠊⡻⣽⠛⠻⣖⣋⣀⡈⠉⠁⣲
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢎⣄⠔⠀⠀⢠⠎⠀⢠⣇⠀⠀⠀⠀⠸⣭⣅⢀⠔⠔⢧⠈⢥⠤⠼⠄⡀⠐⢶⠊⠁
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣮⣼⣋⠔⢁⠔⠁⡠⢀⡎⢹⠀⠀⠀⠀⠀⡇⠀⡉⠀⣄⣠⠧⡜⠢⡀⠠⡤⠤⠤⠇⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⢋⠟⣻⡞⢁⡠⢊⣤⠞⠀⣼⠀⣀⣤⠀⣸⠑⢊⠉⠛⠇⠈⠄⢈⠂⠳⠤⠼⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠴⣲⠟⡡⠚⡊⢁⡽⣛⣾⡿⠋⠀⠀⠉⠞⠋⣽⠜⠉⠲⠚⢆⠴⠤⠒⠴⠂⠉⠉⠀⠀⠀⠀⠀⠀
⠀⠀⢀⣀⠤⠴⠒⣊⡹⣭⣿⡷⠋⠀⣠⠟⣛⣿⠟⠉⠀⠀⠀⣀⣀⠤⠚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⢘⡧⠔⠒⠊⠉⢀⣠⣽⣋⣠⣖⣩⡶⠛⠛⠢⣄⣀⡤⠖⠻⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢾⣅⣀⡤⠤⢒⣋⢥⣲⠿⣋⣵⠟⠉⠀⠀⠀⣤⣤⣽⣣⣰⣦⣿⣷⣒⣤⣶⣴⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠿⠤⡤⠤⠞⢋⡩⠴⠚⠉⠀⠀⠀⠀⠀⠀⠁⠉⠙⡟⣗⡪⠿⣿⢿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠁⠈⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠗⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠚⠓⠾⠓⠒⠚⠲⠞⠆⠲⠖⠂⠀⠗⠛⠓⠛⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                  RedParrot                     $ENDCOLOR"
    echo $ENDCOLOR
    echo ""
}

# functions to format the output
spinner() {
    local i=0 sp n message
    sp='⣾⣽⣻⢿⡿⣟⣯⣷'
    n=${#sp}
    message=$1

    printf ' '

    while sleep 0.2; do
        printf "\r%s %s" "${sp:i++%n:1}" "$message"
    done
}

spinner_end() {
    kill "$!"
    printf "\r"
}

print_info () {
    echo -e "$PURPLE[*]$ENDCOLOR $1"
}

print_success () {
    echo -e "$GREEN[+]$ENDCOLOR $1"
}

print_error () {
    echo -e "$RED[!]$ENDCOLOR $1"
}


# Check if script runs as root
is_user_root () {
    if [ "$EUID" -ne 0 ]; then
        print_error "This script needs to be run using sudo"
        exit 0
    fi
}

# Clean up /tmp/RedParrot folder when failure or end
clean_up_tmp () {
    print_info "Cleaning up"
    spinner &
    rm -rf /tmp/RedParrot/
    spinner_end
    print_success "Cleaned up temp files"
}

# Change to the directory of the script and setup logs and tmp folders
change_directory_script () {
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    cd $SCRIPT_DIR
    
    # Create tmp and logs folders for script execution
    mkdir -p /tmp/RedParrot
    mkdir -p ./logs
    rm -rf /tmp/RedParrot/* ./logs/*
}

# Update system
update_system () {
    print_info "Updating the system"
    spinner &
    (apt update -y && apt full-upgrade -y && apt autoremove -y && apt autoclean -y) 1>logs/update.log 2>logs/errors.log
    spinner_end
    print_success "System updated"
}

# Install pyenv
install_pyenv () {
    print_info "Installing Pyenv"
    if [ -d "/home/$target_user/.pyenv" ]; then
        print_success "Pyenv is already installed"
        return 0
    else
        sudo -u "$target_user" bash -c 'curl -s https://pyenv.run | bash' >logs/dependencies.log 2>logs/errors.log
    fi
    print_success "Pyenv installed"
}

# Install Java version 21 for Burpsuite to work
install_java_21 () {
    print_info "Installing Java version 21 for Burpsuite"
    if [ -d "/usr/lib/jvm/jdk-21" ]; then
        print_success "Java version 21 already installed"
        return 0
    fi
    spinner &
    java_21_url="https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz"
    wget -P /tmp/RedParrot/ $java_21_url 1>logs/java_update.log 2>logs/errors.log
    tar xvf /tmp/RedParrot/openjdk-21.0.2_linux-x64_bin.tar.gz -C /tmp/RedParrot/ 1>logs/java_update.log 2>logs/errors.log
    mv /tmp/RedParrot/jdk-21.0.2/ /usr/lib/jvm/jdk-21 2>logs/errors.log
    spinner_end
    print_success "Java version 21 installed"
}

# Install PowerShell
install_pwsh () {
    print_info "Installing PowerShell"
    spinner &
    if command -v pwsh &> /dev/null; then
        spinner_end
        print_success "PowerShell is already installed"
        return 0
    fi
    wget -P /tmp/RedParrot/ https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/powershell_7.4.6-1.deb_amd64.deb 1>logs/dracula_theme.log 2>logs/errors.log
    sudo dpkg -i /tmp/RedParrot/powershell_7.4.6-1.deb_amd64.deb 1>logs/dracula_theme.log 2>logs/errors.log
    sudo apt-get install -f /tmp/RedParrot/powershell_7.4.6-1.deb_amd64.deb 1>logs/dracula_theme.log 2>logs/errors.log
    spinner_end
    print_success "PowerShell installed"
}

# Add Burpsuite cerificate to CA Certificates
get_burp_cert () {
    print_info "Retrieving and installing Burpsuite certificate to ca-certificates"
    spinner &
     if [ -f "/usr/local/share/ca-certificates/BurpSuiteCA.der" ]; then
        print_success "BurpSuite certificate already installed"
        spinner_end
        return 0
    else
        timeout 45 /usr/lib/jvm/jdk-21/bin/java -Djava.awt.headless=true -jar /usr/share/burpsuite/burpsuite_community.jar < <(echo y) 1>logs/burp_cert.log 2>logs/errors.log &
        sleep 30
        curl http://localhost:8080/cert -o /usr/local/share/ca-certificates/BurpSuiteCA.der 2>logs/errors.log
    fi
    spinner_end
    print_success "Burpsuite certificate installed"
}

# Firefox configurations
firefox () {
    print_info "Configuring Firefox"
    spinner &
    default_profile=$(ls /home/$target_user/.mozilla/firefox/ | grep default-release)
    sqlite3 /home/$target_user/.mozilla/firefox/$default_profile/places.sqlite ".restore ./files/applications/firefox/places.sqlite" 2>logs/errors.log
    cp ./files/applications/firefox/policies.json /usr/lib/firefox/distribution 2>logs/errors.log
    spinner_end
    print_success "Configured Firefox"
}

# Install Dracula theme on the system
install_dracula_theme () {
    print_info "Installing Dracula Theme for GTK"
    spinner &
    rm -rf /usr/share/themes/Dracula
    rm -rf /usr/share/icons/Dracula
    wget -P /tmp/RedParrot https://github.com/dracula/gtk/archive/master.zip 1>logs/dracula_theme.log 2>logs/errors.log
    wget -P /tmp/RedParrot https://github.com/dracula/gtk/files/5214870/Dracula.zip 1>logs/dracula_theme.log 2>logs/errors.log
    unzip /tmp/RedParrot/master.zip -d /tmp/RedParrot 1>logs/dracula_theme.log 2>logs/errors.log
    mv /tmp/RedParrot/gtk-master /tmp/RedParrot/Dracula 1>logs/dracula_theme.log 2>logs/errors.log
    mv /tmp/RedParrot/Dracula /usr/share/themes 1>logs/dracula_theme.log 2>logs/errors.log
    unzip /tmp/RedParrot/Dracula.zip -d /tmp/RedParrot 1>logs/dracula_theme.log 2>logs/errors.log
    mv /tmp/RedParrot/Dracula /usr/share/icons 1>logs/dracula_theme.log 2>logs/errors.log
    spinner_end
    print_success "Dracula theme installed"
}

# Copy Wallpapers
wallpapers () {
    print_info  "Copying Wallpapers"
    spinner &
    cp ./files/wallpapers/* /usr/share/backgrounds
    spinner_end
    print_success "Wallpapers copied"
}

# Install required fonts
install_fonts () {
    print_info "Installing fonts"
    spinner &
    mkdir -p /home/$target_user/.local/share/fonts
    
    # Cascadia Code
    mkdir -p /tmp/RedParrot/CascadiaCode
    wget -P /tmp/RedParrot/CascadiaCode https://github.com/microsoft/cascadia-code/releases/download/v2404.23/CascadiaCode-2404.23.zip 1>logs/install_fonts.log 2>logs/errors.log
    unzip /tmp/RedParrot/CascadiaCode/CascadiaCode-2404.23.zip -d /tmp/RedParrot/CascadiaCode 1>logs/install_fonts.log 2>logs/errors.log
    rsync -a /tmp/RedParrot/CascadiaCode/ttf/ /home/$target_user/.local/share/fonts/ 2>logs/errors.log
    
    spinner_end
    print_success "Fonts installed"
}
# General system settings (Terminal, themes, etc..)
settings () {
    print_info "Configuring user and system settings"
    spinner &
    
    # copy bash scripts for terminal in /etc/htb/ 
    mkdir -p /etc/RedParrot 2> logs/errors.log
    cp -rf ./files/etc/RedParrot/* /etc/RedParrot
    chmod a+x /etc/RedParrot/*

    # Copy user configs to homedir
    cp -rf ./files/homedir/. /home/$target_user/ 2>logs/errors.log

    # Copy theme settings
    mkdir -p /usr/share/themes/RedParrot
    cp -f ./files/usr/share/themes/index.theme /usr/share/themes/RedParrot
    
    #sudo -u $target_user dbus-launch dconf load /org/mate/panel/ < files/system/dconf_panel 2>errors.log
    #dconf load /org/mate/panel/ < files/system/dconf_panel 2>errors.log
    #sudo killall mate-panel 2>errors.log
    sudo -u $target_user dconf load /org/mate/terminal/ < files/dconf_terminal 2>logs/errors.log
    spinner_end
    print_success "Configured user and system settings"
}

main () {
    is_user_root
    change_directory_script
    banner
    update_system
    install_pyenv
    install_java_21
    install_pwsh
    get_burp_cert
    firefox
    install_dracula_theme
    install_fonts
    wallpapers
    settings
    clean_up_tmp
}

main