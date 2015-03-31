#
# Cookbook Name:: chef-tefenua-frontal
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apt::default"
include_recipe "chef-tefenua-frontal::_tomcat"

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
    destination "#{node['tomcat']['webapp_dir']}" + "/" + "tefenua"
    svn_username "#{node['chef-tefenua-frontal']['user_svn']}"
    svn_password "#{node['chef-tefenua-frontal']['passwd_svn']}"
    action :sync
end

chmod = "chown -R #{node['tomcat']['user']}:#{node['tomcat']['group']} #{node['tomcat']['webapp_dir']}" + "/tefenua"

bash 'chown_tefenua_directory' do
   user 'root'
   cwd "#{node['tomcat']['webapp_dir']}" + "/" + "tefenua"
   code <<-EOH
      #{chmod}
   EOH
   notifies :restart, 'service[tomcat7]'
end
