#!/bin/bash

# Error handling for the script
set -e
trap 'error_handling' EXIT
error_handling() {
    exit_status=$?
    error_message=$(cat /tmp/RedParrot/errors.log)
    if [ "$exit_status" -ne 0 ]; then
        printf "\r"
        print_error "$error_message"
        clean_up_tmp
    fi
}

# Re-used variables
target_user=$(ls /home)

# Setting colors for text format
BLUE=$(tput setaf 14)
GREEN=$(tput setaf 10)
RED=$(tput setaf 9)
PURPLE=$(tput setaf 13)
ENDCOLOR=$(tput sgr0)

# Print banner
function banner () {
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
# Functions to format the output
function spinner() {
    local i=0 sp n message
    sp='⣾⣽⣻⢿⡿⣟⣯⣷'
    n=${#sp}
    message=$1

    printf ' '

    while sleep 0.2; do
        printf "\r%s %s" "${sp:i++%n:1}" "$message"
    done
}

function spinner_end() {
    kill "$!"
    printf "\r"
}

function print_info () {
    echo -e "$PURPLE[*]$ENDCOLOR $1"
}

function print_success () {
    echo -e "$GREEN[+]$ENDCOLOR $1"
}

function print_error () {
    echo -e "$RED[!]$ENDCOLOR $1"
}


# Check if script runs as root
function is_user_root () {
    if [ "$EUID" -ne 0 ]; then
        print_error "This script needs to be run using sudo"
        exit 0
    fi
}

function clean_up_tmp () {
    print_info "Cleaning up"
    spinner &
    rm -rf /tmp/RedParrot
    spinner_end
    print_success "Cleanned up /tmp/RedParrot"
}
# Update system
function update_system () {
    print_info "Updating the system"
    spinner &
    mkdir -p /tmp/RedParrot
    rm -rf /tmp/RedParrot/*
    (apt update -y && apt full-upgrade -y && apt autoremove -y && apt autoclean -y) 1>update.log 2>errors.log
    spinner_end
    print_success "System updated"
    
}

function update_java () {
    print_info "Updating Java to version 21 for Burpsuite"
    spinner &
    java_21_url="https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz"
    wget -P /tmp/RedParrot/ $java_21_url 1>java_update.log 2>/tmp/RedParrot/errors.log
    tar xvf /tmp/RedParrot/openjdk-21.0.2_linux-x64_bin.tar.gz -C /tmp/RedParrot/ 1>java_update.log 2>errors.log
    spinner_end
    print_success "Java updated to version 21"
}
# Add Burpsuite cerificate to CA Certificates
function get_burp_cert () {
    print_info "Retrieving and installing Burpsuite certificate to ca-certificates"
    spinner &
    timeout 45 /usr/lib/jvm/jdk-21/bin/java -Djava.awt.headless=true -jar /usr/share/burpsuite/burpsuite_community.jar < <(echo y) 1>burp_cert.log 2>errors.log &
    sleep 30
    curl http://localhost:8080/cert -o /usr/local/share/ca-certificates/BurpSuiteCA.der 2>errors.log
    spinner_end
    print_success "Burpsuite certificate installed"
}

# Firefox
function firefox () {
    print_info "Configuring Firefox"
    spinner &
    default_profile=$(ls /home/$target_user/.mozilla/firefox/ | grep default-release)
    sqlite3 /home/$target_user/.mozilla/firefox/$default_profile/places.sqlite ".restore ./files/firefox/places.sqlite" 2>errors.log
    cp ./files/firefox/policies.json /usr/lib/firefox/distribution 2>errors.logs
    spinner_end
    print_success "Configured Firefox"
}

# Copy Wallpapers
function wallpapers () {
    print_info  "Copying Wallpapers"
    spinner &
    mkdir -p /home/$target_user/Pictures/Wallpapers
    cp ./files/wallpapers/* /home/$target_user/Pictures/Wallpapers
    spinner_end
    print_success "Wallpapers copied"
}


function main () {
    is_user_root
    banner
    update_system
    update_java
    get_burp_cert
    firefox
    wallpapers
    clean_up_tmp
}

main