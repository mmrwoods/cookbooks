
::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default[:automysqlbackup][:mysql_user]     = "automysqlbackup"
default[:automysqlbackup][:mysql_password] = secure_password
