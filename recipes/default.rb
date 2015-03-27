#
# Cookbook Name:: chef-tefenua-frontal
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apt::default"
#include_recipe "chef-tefenua-frontal::_tomcat"

%w( debconf-utils ).each do |pkg|
      package pkg do
      action :install
   end
end

cookbook_file 'oracle8-java.seed' do
   path '/tmp/oracle8-java.seed'
   action :create
   mode '0400'
   owner 'root'
end

bash 'setting-oracle8-java-options' do
   user 'root'
   cwd '/tmp'
   code <<-EOH
      cat /tmp/oracle8-java.seed | debconf-set-selections
   EOH
end


apt_repository "oracle-java" do
   uri "http://ppa.launchpad.net/webupd8team/java/ubuntu"
   #distribution node['lsb']['codename']
   distribution 'precise'
   components ["main"]
   keyserver "hkp://keyserver.ubuntu.com:80"
   key "EEA14886"
   deb_src true
end

package "oracle-java8-installer" do
   action :install
end

package "tomcat7" do
   action :install
end

package "tomcat7-admin" do
   action :install
end

link '/usr/lib/jvm/default-java' do
   to '/usr/lib/jvm/java-8-oracle'
end

cookbook_file 'tomcat-users.xml' do
   path '/etc/tomcat7/tomcat-users.xml'
   action :create
   mode '0640'
   owner 'root'
end

service 'tomcat7' do
   supports status: true, restart: true, reload: true
   action [:enable, :start, :restart]
end

package 'subversion' do
   action :install
end

directory node['tomcat']['webapp_dir'] + '/tefenua' do
   owner "#{node['tomcat']['user']}"
   group "#{node['tomcat']['group']}"
   mode '0755'
   action :create
   recursive true
end

subversion "tefenua" do
    repository "#{node['chef-tefenua-frontal']['frontal_svn_link']}"
    revision "HEAD"
    #destination "#{node['tomcat']['webapp_dir']}" + "/" + "tefenua"
    destination "/var/lib/tomcat7" + "/" + "tefenua"
    svn_username "#{node['chef-tefenua-frontal']['user_svn']}"
    svn_password "#{node['chef-tefenua-frontal']['passwd_svn']}"
    action :sync
end

#chmod = "chown -R #{node['tomcat']['user']}:#{node['tomcat']['group']} #{node['tomcat']['webapp_dir']}" + "/tefenua"
chmod = "chown -R tomcat7:tomcat7 /var/lib/tomcat7/tefenua"

bash 'chown_tefenua_directory' do
   user 'root'
   #cwd "#{node['tomcat']['webapp_dir']}" + "/" + "tefenua"
   cwd "/var/lib/tomcat7/tefenua"
   code <<-EOH
      #{chmod}
   EOH
   notifies :restart, 'service[tomcat7]'
end
