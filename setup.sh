#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage:"
  echo "  $0 [install | uninstall]"
  echo "Examples:"
  echo "  $0 install"
  echo "  $0 uninstall"
  exit 1
fi

function install {
  if [ -d "ja2" ]; then
    echo "ja2 directory already exists!"
    exit 2
  fi

  echo "Downloading..."
  wget --quiet -c https://github.com/ja2-stracciatella/ja2-stracciatella/releases/download/v0.16.1/ja2-stracciatella_0.16.1_amd64.deb
  wget --quiet -c https://rpmfind.net/linux/fedora/linux/releases/28/Everything/x86_64/os/Packages/l/libpng12-1.2.57-5.fc28.x86_64.rpm
  wget --quiet -c http://ftp.us.debian.org/debian/pool/main/libp/libpng/libpng12-0_1.2.50-2+deb8u3_amd64.deb

  echo "Extracting..."
  7z x ja2-stracciatella_0.16.1_amd64.deb
  rm ja2-stracciatella_0.16.1_amd64.deb
  tar xvf data.tar
  rm data.tar

  echo "Installing..."
  mv usr ja2
  echo "install libpng12 manually, i.e:"
  echo "  sudo apt install libpng12-0_1.2.50-2+deb8u3_amd64.deb"
  echo "  sudo dnf install libpng12-1.2.57-5.fc28.x86_64.rpm"
  echo "then remove unused files:"
  echo "  rm libpng12-1.2.57-5.fc28.x86_64.rpm"
  echo "  rm libpng12-0_1.2.50-2+deb8u3_amd64.deb"

  if [ ! -d /usr/share/ja2 ]; then
    echo "copying ja2 to /usr/share/"
    sudo cp -a ja2/share/ja2 /usr/share/
  fi
  if [ ! -f /usr/lib/libstracciatella.so ]; then
    echo "copying libstracciatella.so to /usr/lib/"
    sudo cp ja2/lib/libstracciatella.so /usr/lib/
  fi
  if [ -d /usr/lib64 ]; then
    if [ ! -f /usr/lib64/libstracciatella.so ]; then
      echo "copying libstracciatella.so to /usr/lib64/"
      sudo cp ja2/lib/libstracciatella.so /usr/lib64/
    fi
  fi
}

function uninstall {
  echo "Uninstalling..."

  if [ -d /usr/share/ja2 ]; then
    echo "deleting /usr/share/ja2"
    sudo rm -rf /usr/share/ja2
  fi
  if [ -f /usr/lib/libstracciatella.so ]; then
    echo "deleting /usr/lib/libstracciatella.so"
    sudo rm /usr/lib/libstracciatella.so
  fi
  if [ -d /usr/lib64 ]; then
    if [ -f /usr/lib64/libstracciatella.so ]; then
      echo "deleting /usr/lib64/libstracciatella.so"
      sudo rm /usr/lib64/libstracciatella.so
    fi
  fi
}

case "$1" in
  "install")
    install
  ;;

  "uninstall")
    uninstall
  ;;

  *)
    echo "Wrong usage!"
  ;;
esac
