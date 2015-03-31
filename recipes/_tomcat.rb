#
# Cookbook Name:: chef-tefenua-frontal
# Recipe:: _tomcat
#
# Copyright (C) 2015 Stephane LII
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the Licence

# Java installation
#
node.set['java']['install_flavor'] = 'oracle'
node.set['java']['jdk_version'] = '8'
node.set['java']['oracle']['accept_oracle_download_terms'] = true

include_recipe 'java::default'

# Tomcat installation

node.set['tomcat']['base_version'] = '7'
version = node['tomcat']['base_version']
node.default['tomcat']['java_options'] = '-server -Xms2096m -Xmx2096m -XX:MaxPermSize=256m -Djava.awt.headless=true'
node.default['tomcat']['deploy_manager_packages'] = ["tomcat#{version}-admin"]
node.default['tomcat']['base_instance'] = "tomcat#{version}"
node.default['tomcat']['packages'] = ["tomcat#{version}"]
node.default['tomcat']['user'] = "tomcat#{version}"
node.default['tomcat']['group'] = "tomcat#{version}"
node.default['tomcat']['home'] = "/usr/share/tomcat#{version}"
node.default['tomcat']['base'] = "/var/lib/tomcat#{version}"
node.default['tomcat']['config_dir'] = "/etc/tomcat#{version}"
node.default['tomcat']['log_dir'] = "/var/log/tomcat#{version}"
node.default['tomcat']['tmp_dir'] = "/tmp/tomcat#{version}-tmp"
node.default['tomcat']['work_dir'] = "/var/cache/tomcat#{version}"
node.default['tomcat']['context_dir'] = "#{node['tomcat']['config_dir']}/Catalina/localhost"
node.default['tomcat']['webapp_dir'] = "/var/lib/tomcat#{version}/webapps"
node.default['tomcat']['keytool'] = 'keytool'
node.default['tomcat']['lib_dir'] = "#{node['tomcat']['home']}/lib"
node.default['tomcat']['endorsed_dir'] = "#{node['tomcat']['lib_dir']}/endorsed"

include_recipe 'tomcat::default' 

service 'tomcat7' do
    supports status: true, restart: true, reload: true
    action [:enable, :start, :restart]
end
