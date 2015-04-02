#
# Cookbook Name:: chef-tefenua-frontal
# Recipe:: internal
#
# Copyright (C) 2014 Stephane LII
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
  include_recipe 'apache2'
  include_recipe 'apache2::mod_ssl'
  include_recipe 'apache2::mod_proxy'
  include_recipe 'apache2::mod_proxy_http'
  include_recipe 'apache2::mod_proxy_ajp'
  include_recipe 'apache2::mod_proxy_balancer'
  include_recipe 'apache2::mod_proxy_connect'
  include_recipe 'apache2::mod_rewrite'

if node['chef-tefenua-frontal']['databag']['encrypted'] == true
  secret = Chef::EncryptedDataBagItem.load_secret(node['chef-tefenua-frontal']['databag']['secret_path'])
  item =  Chef::EncryptedDataBagItem.load(node['chef-tefenua-frontal']['databag']['name'], node['chef-tefenua-frontal']['databag']['item'], secret)
else
  item = data_bag_item(node['chef-tefenua-frontal']['databag']['name'], node['chef-tefenua-frontal']['databag']['item'])
end

item['apps'].each do |apps|
   external_name=apps['name'] + '.gov.pf'
   reverse_name=apps['real_server']
   redirect_ssl=apps['redirect_ssl']
   cakey=apps['cakey']
   cakeyname=apps['cakeyname']
   pemkey=apps['key']
   crtkey=apps['cert']

   template '/etc/ssl/certs/' + cakeyname + '.crt' do
    source 'certificate.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      certifcate: cakey
    )
  end


  template '/etc/ssl/certs/' + external_name + '.crt' do
    source 'certificate.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      certifcate: crtkey
    )
  end

  template '/etc/ssl/private/' + external_name + '.key' do
    source 'certificate.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      certifcate: pemkey
    )
  end

  template "#{node['apache']['dir']}/sites-available/#{external_name}.conf" do
    source 'ssl.erb'
    owner 'root'
    group node['apache']['root_group']
    mode '0644'
    cookbook params[:cookbook] if params[:cookbook]
    variables(
      application_name: 'tefenua',
      external_name: external_name,
      cakey: cakeyname + '.crt',
      crtkey: external_name + '.crt',
      pemkey: external_name + '.key'
    )
  end

  apache_site external_name do
    enable true
  end


end
