#
# Cookbook Name:: vote_deploy
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'database::postgresql'
include_recipe 'rvm::user'

git "/vagrant/vote" do
  repository 'https://github.com/sd-kin/vote.git'
  reference 'master'
  action :checkout
end

ruby_block 'ddd' do
block do
file = File.open '/vagrant/vote/config/database.yml'
databases = YAML.load file
end
end

connection_info = {
        host: 'localhost',
        username: 'postgres',
        password: 'postgres'
      }

YAML.load(File.open '/vagrant/vote/config/database.yml').each do |db|    

  postgresql_database_user db.last['username'] do
    connection connection_info
    password db.last['password']
    action :create
  end

  postgresql_database db.last['database'] do
    connection connection_info
    owner db.last['username']
    action :create
  end
end

rvm_shell 'bundle_install' do
  user 'vagrant'
  cwd '/vagrant/vote'
  code 'bundle install'
end

rvm_shell 'rake_db_migrate' do
  user 'vagrant'
  cwd '/vagrant/vote'
  code 'rake db:migrate'
end

