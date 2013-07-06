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
require 'minitest/spec'

describe_recipe 'openvpn::client_test' do
  it 'creates /etc/openvpn/gw_client.conf' do
    gw = file("/etc/openvpn/gw_client.conf")
    gw.must_exist.with(:owner, node['openvpn']['uid']).with(:group, node['openvpn']['gid'])
    ['ca /etc/ssl/demoCA/demoCA.crt',
     'cert /etc/ssl/demoCA/demoCA-client.crt',
     'key /etc/ssl/demoCA/demoCA-client.key',
     'dev tun0',
     'dev-type tap',
     'proto udp',
     'port 1195',
     'tls-client',
     "user #{node['openvpn']['uid']}",
     "group #{node['openvpn']['gid']}",
     "ifconfig 10.7.30.12 255.255.255.0"
    ].each do |l|
      gw.must_include l
    end
  end

  it 'starts openvpn' do
    assert_sh 'pgrep openvpn'
  end

  it 'creates tun0' do
    assert_sh 'ifconfig tun0'
  end

  it 'ping remote via openvpn' do
    assert_sh 'sleep 30 && ping -c 1 10.7.30.10'
  end
end
