#
# Author:: Ken-ichi TANABE (<nabeken@tknetworks.org>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'spec_helper'

describe 'openvpn::client_test' do
  before(:each) { ::File.stub(:exists?).and_call_original }

  let(:dev) {
    {
      'openbsd' => 'tun',
      'freebsd' => 'tap',
      'debian'  => 'tap',
    }
  }

  # tests for OpenBSD/FreeBSD/Debian
  %w{openbsd freebsd debian}.each do |os|
    context "on #{os}" do
      include_context os do
        it 'should create openvpn configuration' do
          Chef::Recipe.any_instance.stub(:data_bag_item).with('openvpn', 'routes').and_return(
            {'gw' => ["route 10.0.5.0 255.255.255.0 10.7.30.10"]}
          )
          Chef::Recipe.any_instance.stub(:data_bag_item).with('openvpn', 'ifconfig_gw').and_return(
            {'client.example.org' => "10.7.30.12 255.255.255.0"}
          )
          chef_run.node.automatic_attrs['fqdn'] = 'client.example.org'
          chef_run.converge 'openvpn::client_test'
          ['ca /etc/ssl/demoCA/demoCA.crt',
           'cert /etc/ssl/demoCA/demoCA-client.crt',
           'key /etc/ssl/demoCA/demoCA-client.key',
           "dev #{dev[os]}0",
           'dev-type tap',
           'proto udp',
           'port 1195',
           'remote 192.168.67.10',
           'tls-client',
           'fragment 1280',
           'mssfix',
           "user #{chef_run.node['openvpn']['uid']}",
           "group #{chef_run.node['openvpn']['gid']}",
           "route 10.0.5.0 255.255.255.0 10.7.30.10",
           "ifconfig 10.7.30.12 255.255.255.0",
          ].each do |l|
            expect(chef_run).to create_file_with_content "#{chef_run.node['openvpn']['dir']}/gw_client.conf", l
          end
        end
      end
    end
  end
end
