#!/bin/bash

set -ex

function install() {
    hostname cwr
    apt install software-properties-common network-manager curl gnupg git -y

    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

    curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

    curl https://repo.skype.com/data/SKYPE-GPG-KEY | sudo apt-key add -
    dpkg -s apt-transport-https > /dev/null || bash -c "sudo apt-get update; sudo apt-get install apt-transport-https -y"
    echo "deb [arch=amd64] https://repo.skype.com/deb stable main" | sudo tee /etc/apt/sources.list.d/skype-stable.list

    curl https://www.charlesproxy.com/packages/apt/PublicKey | sudo apt-key add -
    sudo sh -c 'echo deb https://www.charlesproxy.com/packages/apt/ charles-proxy main > /etc/apt/sources.list.d/charles.list'

    curl https://get.docker.com | sh

    usermod -a -G docker cwr
    sed -r 's#^(%sudo\s.+)$#\1\ncwr\tALL=(ALL) NOPASSWD: ALL#g' /etc/sudoers -i

    git clone --bare https://github.com/cwrau/.files /home/cwr/.files

    git --git-dir=/home/cwr/.files/ --work-tree=/home/cwr checkout -f

    git clone https://github.com/seebi/dircolors-solarized /home/cwr/.dircolors
    pushd /home/cwr/.dircolors
    git fetch
    popd

    git clone https://github.com/magicmonty/bash-git-prompt /home/cwr/.bash-git-prompt
    pushd /home/cwr/.bash-git-prompt
    git fetch
    popd

    git clone https://github.com/amix/vimrc /home/cwr/.vim_runtime
    pushd /home/cwr/.vim_runtime
    git fetch
    popd

    mkdir /home/cwr/.config
    echo "yes" > /home/cwr/.config/gnome-initial-setup-done

    chown cwr:cwr -R /home/cwr

    runuser -l cwr -c 'sh -c ". /home/cwr/.vim_runtime/install_awesome_vimrc.sh"'
    runuser -l cwr -c 'bash -c ". /home/cwr/.bashrc; updateCompose"'

    pushd /tmp
    curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep "browser_download_url.*deb" | cut -d : -f 2,3 | tr -d \" | wget -i -
    curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | grep "browser_download_url.*deb" | grep -v musl | grep amd64 | cut -d : -f 2,3 | tr -d \" | wget -i -
    curl -s https://api.github.com/repos/scaleway/scaleway-cli/releases/latest | grep "browser_download_url.*deb" | grep amd64 | cut -d : -f 2,3 | tr -d \" | wget -i -
    dpkg -i *.deb
    popd

    pushd /home/cwr
    fd -H -t d -x chmod g+s
    popd

    add-apt-repository ppa:rabbitvcs/ppa -y
    apt-add-repository ppa:system76/pop -y
    apt update
    apt upgrade -y
    systemctl enable --now network-manager

    apt install curl pop-desktop fonts-firacode google-chrome-stable code skypeforlinux subversion openjdk-8-jdk network-manager-openvpn-gnome blueman vim gnome-tweak-tool steam-installer evolution charles-proxy rabbitvcs-nautilus3 ktorrent -y

    reboot
}

# wrapped up in a function so that we have some protection against only getting half the file during "curl | sh"
install
