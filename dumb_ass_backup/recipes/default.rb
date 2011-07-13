#
# Cookbook Name:: dumb_ass_backup
# Recipe:: default
#

# TODO: ensure ruby has been installed

cookbook_file "/usr/local/sbin/dumb_ass_daily_backup.rb" do
  source "dumb_ass_daily_backup.rb"
  mode "0700"
  owner "root"
  group "root"
end

template "/etc/dumb_ass_daily_backup.yml" do
  mode "0600"
  owner "root"
  group "root"
  source "dumb_ass_daily_backup.yml.erb"
end

cron "dumb-ass-daily-backup" do
  hour "4"
  minute "16"
  command "/usr/local/sbin/dumb_ass_daily_backup.rb"
end
