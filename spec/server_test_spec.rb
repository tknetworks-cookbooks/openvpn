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

describe 'openvpn::server_test' do
  let (:chef_run) {
    ChefSpec::ChefRunner.new(:step_into => ['openvpn_server'],
                             :evaluate_guards => true) do |node|
      node.automatic_attrs['platform'] = 'openbsd'
      node.set['etc']['passwd']['root']['gid'] = 0
    end
  }

  it 'should create openvpn confiuration' do
    chef_run.stub_command('/sbin/ifconfig tun0', false)

    chef_run.converge 'openvpn::server_test'
    ['ca /etc/ssl/demoCA/demoCA.crt',
     'cert /etc/ssl/demoCA/demoCA.crt',
     'key /etc/ssl/demoCA/demoCA-without-pass.key',
     'dev tun0',
     'dev-type tap',
     'proto udp',
     'port 1195',
     'local 192.168.67.10',
     'mode server',
     'tls-server',
     "max-clients #{chef_run.node['openvpn']['max_clients']}",
     "user #{chef_run.node['openvpn']['uid']}",
     "group #{chef_run.node['openvpn']['gid']}",
    ].each do |l|
      expect(chef_run).to create_file_with_content "#{chef_run.node['openvpn']['dir']}/gw.conf", l
    end
  end
end
