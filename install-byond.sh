#!/bin/sh
set -e
if [ -f ~/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}/byond/bin/DreamMaker ];
then
  echo "Using cached directory."
else
  echo "Setting up BYOND."
  mkdir -p ~/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}
  cd ~/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}
  echo "Installing DreamMaker to $PWD"
  wget -O byond.zip "http://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip"
  unzip -o byond.zip
  cd byond
  make here
fi
