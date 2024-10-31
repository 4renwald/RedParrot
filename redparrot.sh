#!/bin/bash

# Error handling for the script
set -e
trap 'error_handling' EXIT
error_handling() {
    exit_status=$?
    error_message=$(cat errors.log)
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

# s to format the output
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

# Change to the directory of the script
change_directory_script () {
  SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  cd $SCRIPT_DIR
}

# Update system
update_system () {
    print_info "Updating the system"
    spinner &
    mkdir -p /tmp/RedParrot
    rm -rf /tmp/RedParrot/*
    (apt update -y && apt full-upgrade -y && apt autoremove -y && apt autoclean -y) 1>update.log 2>errors.log
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
        sudo -u "$target_user" bash -c 'curl -s https://pyenv.run | bash' >dependencies.log 2>errors.log
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
    wget -P /tmp/RedParrot/ $java_21_url 1>java_update.log 2>errors.log
    tar xvf /tmp/RedParrot/openjdk-21.0.2_linux-x64_bin.tar.gz -C /tmp/RedParrot/ 1>java_update.log 2>errors.log
    mv /tmp/RedParrot/jdk-21.0.2/ /usr/lib/jvm/jdk-21 2>>errors.log
    spinner_end
    print_success "Java version 21 installed"
}

# Add Burpsuite cerificate to CA Certificates
get_burp_cert () {
    print_info "Retrieving and installing Burpsuite certificate to ca-certificates"
    spinner &
    timeout 45 /usr/lib/jvm/jdk-21/bin/java -Djava.awt.headless=true -jar /usr/share/burpsuite/burpsuite_community.jar < <(echo y) 1>burp_cert.log 2>errors.log &
    sleep 30
    curl http://localhost:8080/cert -o /usr/local/share/ca-certificates/BurpSuiteCA.der 2>errors.log
    spinner_end
    print_success "Burpsuite certificate installed"
}

# Firefox configurations
firefox () {
    print_info "Configuring Firefox"
    spinner &
    default_profile=$(ls /home/$target_user/.mozilla/firefox/ | grep default-release)
    sqlite3 /home/$target_user/.mozilla/firefox/$default_profile/places.sqlite ".restore ./files/applications/firefox/places.sqlite" 2>errors.log
    cp ./files/applications/firefox/policies.json /usr/lib/firefox/distribution 2>errors.log
    spinner_end
    print_success "Configured Firefox"
}

# Copy Wallpapers
wallpapers () {
    print_info  "Copying Wallpapers"
    spinner &
    cp ./files/wallpapers/* /usr/share/backgrounds
    sudo -u $target_user gsettings set org.mate.background picture-filename /usr/share/backgrounds/w01.jpg
    spinner_end
    print_success "Wallpapers copied"
}

# General system settings (Terminal, themes, etc..)
settings () {
    print_info "Configuring user and system settings"
    spinner &
    mkdir -p /etc/htb 2> errors.log
    cp -rf ./files/system/scripts/* /etc/htb
    chmod a+x /etc/htb/*
    cp -rf ./files/homedir/. /home/$target_user/ 2>errors.log
    cp -rf ./files/system/themes/ /usr/share/themes 2>errors.log
    gsettings set org.mate.interface gtk-theme 'htb-gtk-theme' 2>errors.log
    gsettings set org.mate.interface icon-theme 'Hack-The-Box-Icons' 2>errors.log
    gsettings set org.mate.caja.preferences background-color '#0C151F' 2>errors.log
    gsettings set org.mate.caja.preferences background-set true 2>errors.log
    gsettings set org.mate.background picture-filename '/usr/share/backgrounds/w01.jpg' 2>errors.log
    #sudo -u $target_user dbus-launch dconf load /org/mate/panel/ < files/system/dconf_panel 2>errors.log
    #dconf load /org/mate/panel/ < files/system/dconf_panel 2>errors.log
    sudo killall mate-panel 2>errors.log
    dconf load /org/mate/terminal/ < files/system/dconf_terminal 2>errors.log
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
    #get_burp_cert
    firefox
    wallpapers
    settings
    clean_up_tmp
}

main