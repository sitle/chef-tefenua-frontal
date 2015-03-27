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
node.set['tomcat']['user'] = 'tomcat7'
node.set['tomcat']['group'] = 'tomcat7'
node.set['tomcat']['home'] = '/usr/share/tomcat7'
node.set['tomcat']['config_dir'] = '/etc/tomcat7'
node.set['tomcat']['base'] = '/var/lib/tomcat7'
node.set['tomcat']['config_dir'] = '/etc/tomcat7'
node.set['tomcat']['log_dir'] = '/var/log/tomcat7'
node.set['tomcat']['tmp_dir'] = '/tmp/tomcat7-tmp'
node.set['tomcat']['work_dir'] = '/var/cache/tomcat7'
node.set['tomcat']['webapp_dir'] = '/var/lib/tomcat7/webapps'
node.set['tomcat']['keytool'] = '/usr/bin/keytool'
node.set['tomcat']['java_options'] = '-Djava.awt.headless=true -Xms2G -Xmx2G -XX:+UseConcMarkSweepGC -XX:MaxPermSize=512m'
include_recipe 'tomcat::default'

service 'tomcat7' do
    supports status: true, restart: true, reload: true
    action [:enable, :start, :restart]
end
