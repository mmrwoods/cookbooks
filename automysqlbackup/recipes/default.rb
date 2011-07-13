# Cookbook Name:: automysqlbackup 
# Recipe:: default

cookbook_file "/usr/local/sbin/automysqlbackup.sh" do
  source "automysqlbackup-2.5.1-01.sh"
  mode "0700"
  owner "root"
  group "root"
end

cron "automysqlbackup" do
  hour "0"
  minute "16"
  command "/usr/local/sbin/automysqlbackup.sh"
end

execute "permissions-for-backup-user" do
  grant_select = "GRANT SELECT, LOCK TABLES ON *.* TO '#{node[:automysqlbackup][:mysql_user]}'@'localhost' IDENTIFIED BY '#{node[:automysqlbackup][:mysql_password]}'"
  command "/usr/bin/mysql -u root #{node[:mysql][:server_root_password].empty? ? '' : '-p' }#{node[:mysql][:server_root_password]} -e \"#{grant_select}\""
  action :run
  not_if "/usr/bin/mysql -u #{node[:automysqlbackup][:mysql_user]} -p#{node[:automysqlbackup][:mysql_password]} -e 'show databases;'"
end

directory "/etc/automysqlbackup" do
  owner "root"
  group "root"
  mode "0700"
  action :create
end

template "/etc/automysqlbackup/automysqlbackup.conf" do
  mode "0600"
  owner "root"
  group "root"
  source "automysqlbackup.conf.erb"
end

