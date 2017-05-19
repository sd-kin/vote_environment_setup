#!/usr/bin/env bash

username="$1"
password="$2"

sudo locale-gen en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8

sudo apt-get update

sudo apt-get install -y build-essential git curl postgresql postgresql-contrib libpq-dev libmagickwand-dev imagemagick

#sudo -u postgres createuser --superuser vagrant

echo adding swap file
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap defaults 0 0' >> /etc/fstab

# redis
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:rwky/redis
sudo apt-get update
sudo apt-get install -y redis-server

# add ssh key to github
if [ -f "/home/vagrant/.ssh/id_rsa.pub" ]
then
  echo "existing ssh key found"
else
  su - vagrant -c "ssh-keygen -f /home/vagrant/.ssh/id_rsa -t rsa -N ''"
  ssh_key=`cat /home/vagrant/.ssh/id_rsa.pub`
  curl -u $username:$password -d "{\"title\":\"vagrant-key\",\"key\":\"$ssh_key\"}" https://api.github.com/user/keys
fi

# rvm and ruby
if su - vagrant -c 'command -v rvm >/dev/null 2>&1'
then
  echo 'rvm installed'
else
  su - vagrant -c 'curl -sSL https://get.rvm.io | bash -s stable --ruby=2.3.1 --with-gems="bundler"'
  su - vagrant -c 'rvm rvmrc warning ignore allGemfiles'
fi

# node
if su - vagrant -c 'command -v node >/dev/null 2>&1'
then
  echo 'nodejs installed'
else
  su - vagrant -c 'curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -'
  su - vagrant -c 'sudo apt-get install -y nodejs'
fi

# phantomjs
if su - vagrant -c 'command -v phantomjs >/dev/null 2>&1'
then
  echo 'phantomjs installed'
else
  PHANTOM_VERSION="phantomjs-2.1.1"
  ARCH=$(uname -m)

  if ! [ $ARCH = "x86_64" ]; then
    $ARCH="i686"
  fi

  PHANTOM_JS="$PHANTOM_VERSION-linux-$ARCH"

  sudo apt-get install build-essential chrpath libssl-dev libxft-dev -y
  sudo apt-get install libfreetype6 libfreetype6-dev -y
  sudo apt-get install libfontconfig1 libfontconfig1-dev -y

  cd ~
  wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
  sudo tar xvjf $PHANTOM_JS.tar.bz2

  sudo mv $PHANTOM_JS /usr/local/share
  sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin
fi

# add github to known hosts
if [ -f "/home/vagrant/.ssh/known_hosts" ]
then
  echo "existing known hosts found"
else
  su - vagrant -c 'ssh -o "StrictHostKeyChecking no" github.com'
fi

# deploy project
sudo -u postgres psql -c "create role vote_dev with createdb login password 'vote_dev'"
sudo -u postgres psql -c "create role vote_test with createdb login password 'vote_test'"
su - vagrant -c "git clone git@github.com:sd-kin/vote.git /vagrant/vote"
su - vagrant -c "cd /vagrant/vote && bundle"
su - vagrant -c "cd /vagrant/vote && rake db:setup"
#su - vagrant -c "cd /vagrant/vote && rake db:migrate && RAILS_ENV=test rake db:migrate"

apt-get -y autoremove

# initial setup for first provisioning
if [ -n "${SECRET_KEY_BASE}" ]
then
  echo 'Skip setup - not firs provision'
else
  echo "cd /vagrant/vote" >> /home/vagrant/.bashrc
fi

echo "All done installing!
Next steps: type 'vagrant ssh' to log into the machine."
