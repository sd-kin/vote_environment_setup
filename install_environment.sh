if hash virtualbox 2>/dev/null; then
  echo "virtualbox already installed"
else
  sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian xenial contrib"
  wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install virtualbox-5.1
  sudo apt-get install dkms
fi

if hash vagrant 2>/dev/null; then
  echo "vagrant already installed"
else
  wget "https://releases.hashicorp.com/vagrant/1.8.5/vagrant_1.8.5_x86_64.deb"
  sudo dpkg -i vagrant_1.8.5_x86_64.deb
  rm -rf vagrant_1.8.5_x86_64.deb
  vagrant plugin install vagrant-vbguest
  vagrant plugin install vagrant-librarian-chef-nochef
fi

vagrant up --provision


