#!/bin/bash

# This code is based on: https://github.com/BlackCorsair/install-jdk-on-steam-deck

# Set the variables for JDK 21
JDK_VERSION="21"
JDK_URL="https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz"
JDK_CHECKSUM_URL="https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz.sha256"
JDK_FILE_NAME="jdk-21_linux-x64_bin.tar.gz"
JDK_CHECKSUM_FILE_NAME="jdk-21_linux-x64_bin.tar.gz.sha256"
INSTALLATION_DIR="${HOME}/.local/jdk-${JDK_VERSION}"
CURRENT_DIR=$(pwd)

log_info() {
    echo "[INFO] $1"
}

exit_if_jdk_is_installed() {
    if type -p java > /dev/null; then
        log_info "Java is already installed"
        exit 1
    fi
}

install_jdk() {
    # Download JDK
    wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" $JDK_URL -O $JDK_FILE_NAME

    # Unzip the downloaded file
    tar -xvf $JDK_FILE_NAME

    # Move the JDK to the installation directory
    mv jdk-21.0.2 $INSTALLATION_DIR
}

# This will set JAVA_HOME and will also append the java/bin folder to PATH
set_variables_for_the_installation() {
    touch ~/.profile
    if ! grep "JAVA_HOME" ~/.bashrc ~/.profile
    then
        echo "export JAVA_HOME=${INSTALLATION_DIR}" >> ~/.profile
        echo "export PATH=\$PATH:${INSTALLATION_DIR}/bin" >>  ~/.profile
        echo "[[ -f ~/.profile ]] && source ~/.profile" >> ~/.bashrc
    fi
}

#### MAIN ####

log_info "Checking if you already have java installed"
exit_if_jdk_is_installed

log_info "Installing jdk-$JDK_VERSION on your local folder '.local/'..."

log_info "Downloading and decompressing jdk21 from oracle page..."
install_jdk
log_info "JDK downloaded and extracted into ${INSTALLATION_DIR}"

log_info "Setting environment variables if not already set"
set_variables_for_the_installation

log_info "Checking that java is properly installed..."
# shellcheck disable=SC1090
source ~/.bashrc
if "${INSTALLATION_DIR}/bin/java" -version
then
    log_info "Java is succesfully installed!"
fi