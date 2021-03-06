# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 3000 , host: 3000
  config.vm.network "forwarded_port", guest: 5432 , host: 5432

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder ".", "/vagrant"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
      # Customize the amount of memory on the VM:
      vb.memory = "2048"
   end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks", "site-cookbooks"]
    
    chef.add_recipe "apt"
    chef.add_recipe "nodejs"
    chef.add_recipe "ruby_build"
    chef.add_recipe "phantomjs2::default"
    chef.add_recipe "rvm::user"
    chef.add_recipe "rvm::vagrant"
    chef.add_recipe "postgresql::server"
    chef.add_recipe "vote_deploy::default"
    chef.add_recipe "redis2::default_instance"

    chef.json = {
      #<rvm>
      rvm: {
            user_installs: [{
                             user: 'vagrant',
                             rubies: ['2.3.0'],
                             default_ruby: '2.3.0'
                           }],
            vagrant: {
                      system_chef_solo: '/opt/chef/bin/chef-solo'
                     }
           }, #</rvm>

      #<postgres>
      postgresql: {
                   config: {
                             ssl: false,
                             listen_addresses: '*'
                            },
                   password: {
                              postgres: 'postgres'
                             },
                   pg_hba: [{
                            type: 'local',
                            db:   'all',
                            user: 'postgres',
                            addr:  nil,
                            method: 'ident'
                           },
                           {
                            type: 'local',
                            db:   'all',
                            user: 'all',
                            addr:  nil,
                            method: 'md5'
                           },
                            {
                            type: 'host',
                            db:   'all',
                            user: 'all',
                            addr:  '127.0.0.1/32',
                            method: 'md5'
                           }]
                   }#</postgres>

                }
  end
end
