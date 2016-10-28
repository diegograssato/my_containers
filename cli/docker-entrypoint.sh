#!/usr/bin/env bash

# Default SSH key name
if [ -z $SSH_KEY_NAME ]; then SSH_KEY_NAME='id_rsa'; fi
echo "Using SSH key name: $SSH_KEY_NAME"

# Copy SSH key pairs.
# @param $1 path to .ssh folder
copy_ssh_key ()
{
  local path="$1/$SSH_KEY_NAME"
  if [ -f $path ]; then
    echo "Copying SSH key $path from host..."
    sudo cp $path ${HOME}/.ssh/id_rsa
    sudo chmod 600 ${HOME}/.ssh/id_rsa
    sudo chown $(id -u):$(id -g) -R ${HOME}/.ssh
  fi
}

# Copy GIT settings from host
# @param $1 path to the home directory (parent of the .gitconfig directory)
copy_dot_git ()
{
  local path="$1/.gitconfig"
  if [ -f $path ]; then
    echo "Copying GIT settings in $path from host..."
    sudo cp $path ${HOME}/.gitconfig
    sudo chown $(id -u):$(id -g) ${HOME}/.gitconfig
  fi
}

# Copy COMPOSER settings from host
# @param $1 path to the home directory (parent of the .composer/auth.json directory)
copy_dot_composer ()
{
  local path="$1/.composer"
  if [ -d $path ]; then

    sudo find /.home-linux/.composer/ -maxdepth 1 -type f | xargs -I {} echo "Copying COMPOSER settings in {} from host..."
    mkdir -p ${HOME}/.composer
    sudo find $path -maxdepth 1 -type f | xargs -I {} cp {} ${HOME}/.composer/
    sudo find $path -maxdepth 1 -type f | xargs -I {} sudo chown $(id -u):$(id -g) {} ${HOME}/.composer/
    sudo chown $(id -u):$(id -g) ${HOME}/.composer -R

  fi
}

# Copy SSH keys from host if available
copy_ssh_key '/.home/.ssh' # Generic
copy_ssh_key '/.home-linux/.ssh' # Linux (docker-compose)
copy_ssh_key '/.home-b2d/.ssh' # boot2docker (docker-compose)

# Copy Composer settings from host if available
copy_dot_composer '/.home' # Generic
copy_dot_composer '/.home-linux' # Linux (docker-compose)
copy_dot_composer '/.home-b2d' # boot2docker (docker-compose)

# Copy Drush settings from host if available
copy_dot_git '/.home' # Generic
copy_dot_git '/.home-linux' # Linux (docker-compose)
copy_dot_git '/.home-b2d' # boot2docker (docker-compose)
 
# Execute passed CMD arguments
exec "$@"
