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

connection_info = {
        host: 'localhost',
        username: 'postgres',
        password: 'postgres'
      }   

postgresql_database_user 'vote_dev' do
  connection connection_info
  password 'vote_dev'
  action :create
end
postgresql_database_user 'vote_test' do
  connection connection_info
  password 'vote_test'
  action :create
end

postgresql_database 'vote_dev' do
  connection connection_info
  owner 'vote_dev'
  action :create
end

postgresql_database 'vote_test' do
  connection connection_info
  owner 'vote_test'
  action :create
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

