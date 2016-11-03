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

CURL="sudo curl"
CHMOD="sudo chmod"
CHOWN="sudo chown"
# Enabling DRUSH
cli_enable_drush() {

  echo -e "Enabling drupal cli."
  ${CURL} -fsSL "https://github.com/drush-ops/drush/releases/download/8.1.6/drush.phar" -o /usr/local/bin/drush
  ${CHMOD} +x /usr/local/bin/drush
  # # Drush modules
  drush dl registry_rebuild-7.x-2.2
  drush cc drush

}

# Enabling DRUPAL DEV
cli_enable_drupal() {

  echo -e "Enabling drupal develop mode."
  composer global require drupal/console:0.11.3 \
    --prefer-dist \
    --optimize-autoloader \
    --sort-packages
  #${CHMOD} +x /usr/local/bin/drupal
  [[ ! -d /var/console ]] && sudo mkdir /var/console
  ${CHOWN} docker. /var/console -R
  mkdir -p $HOME/.config/fish/completions
  [[ ! -d $HOME/.console ]] && mkdir -p $HOME/.console && chown docker. $HOME/.console -R
  $HOME/.composer/vendor/bin/drupal init
  if [ -f "$HOME/.console/console.rc" ]; then
    source "$HOME/.console/console.rc" 2>/dev/null
  fi

  if [ -f $HOME/.console/drupal.fish ]; then
    ln -s $HOME/.console/drupal.fish $HOME/.config/fish/completions/drupal.fish
  fi
  $HOME/.composer/vendor/bin/drupal check

}

# Enabling PHP CODESNIFFER
cli_enable_code_sniffer() {

  echo -e "Enabling PHP CS."
  ${CURL} -fsSL "https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar" -o /usr/local/bin/phpcbf
  ${CURL} -fsSL "https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar" -o /usr/local/bin/phpcs

  ${CHMOD} 777 /usr/local/bin/phpcbf
  ${CHMOD} 777 /usr/local/bin/phpcs

}

# Enabling Sonar Scanner
cli_enable_sonar_scanner() {

  echo -e "Enabling Sonar Scanner."

  # Sonar
  mkdir -p /home/docker/.sonar
  cd /opt/
  #wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-2.8.zip -O /home/docker/.sonar/sonar-scanner.zip
  sudo unzip sonar-scanner-2.6.zip
  sudo mv sonar-scanner-2.6 /home/docker/.sonar/sonar-scanner
  ${CHMOD} 777 -R /home/docker/.sonar/sonar-scanner/bin/*
  sudo rm sonar-scanner-2.6.zip

}

# Enabling Symfony DEV
cli_enable_symfony_dev() {

  echo -e "Enabling symfony in develop mode."
  ${CURL} -LsS https://symfony.com/installer -o /usr/local/bin/symfony
  ${CHMOD} 777 /usr/local/bin/symfony

}

[[ ${CLI_SYMFONY_DEV} =~ ([Tt][Rr][Uu][Ee]|[Yy][Ee][Ss]) ]] && cli_enable_symfony_dev
[[ ${CLI_DRUSH} =~ ([Tt][Rr][Uu][Ee]|[Yy][Ee][Ss]) ]] && cli_enable_drush
[[ ${CLI_DRUPAL_CLI} =~ ([Tt][Rr][Uu][Ee]|[Yy][Ee][Ss]) ]] && cli_enable_drupal
[[ ${CLI_CS} =~ ([Tt][Rr][Uu][Ee]|[Yy][Ee][Ss]) ]] && cli_enable_code_sniffer
[[ ${CLI_SONAR} =~ ([Tt][Rr][Uu][Ee]|[Yy][Ee][Ss]) ]] && cli_enable_sonar_scanner

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
