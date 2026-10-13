#!/bin/bash

# ========= DISABLE PASSWORD
sudo passwd uczen -d
sudo sed -i 's/#User=/User=uczen/' /etc/plasmalogin.conf
sudo sed -i 's/#Session=/Session=plasma.desktop/' /etc/plasmalogin.conf

# ========= UPGRADE ALL
sudo dnf upgrade --refresh

# ========= BASIC SETUP
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remote-delete fedora

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1 -y

# ========= VSCODE
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

dnf check-update -y
sudo dnf install code -y

# ========= C/C++ TOOLS
sudo dnf install @development-tools gcc gcc-c++ -y

# ========= QT
sudo dnf install qt6-*{devel,doc}* qt-creator -y

# ========= ANDROID STUDIO
mkdir -p /tmp/system-setup && cd /tmp/system-setup
wget https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.2.1.8/android-studio-rabbit1-linux.tar.gz -O android-studio.tar.gz

sudo tar -zxvf android-studio.tar.gz -C /opt

sudo tee /usr/share/applications/android-studio.desktop > /dev/null <<'EOF'
[Desktop Entry]
Type=Application
Version=1.0
Name=Android Studio
Comment=IDE for Android development
Path=/opt/android-studio
Exec=/opt/android-studio/bin/studio
Icon=/opt/android-studio/bin/studio.svg
Terminal=false
EOF

# ========= DESKTOP ICONS
create_desktop_icons() {
  local desktop_dir=$1
  ln -s /usr/share/applications/android-studio.desktop $HOME/$desktop_dir/android-studio.desktop
  ln -s /usr/share/applications/com.microsoft.VSCode.desktop $HOME/$desktop_dir/vscode.desktop
  ln -s /usr/share/applications/org.qt-project.qtcreator.desktop $HOME/$desktop_dir/qtcreator.desktop
}

ls $HOME/Pulpit > /dev/null && create_desktop_icons Pulpit
ls $HOME/Desktop > /dev/null && create_desktop_icons Desktop

# ========= REBOOT
reboot
