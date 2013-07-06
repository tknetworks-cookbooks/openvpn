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
directory "/etc/ssl/demoCA"
cookbook_file "/etc/ssl/demoCA/demoCA.crt"
cookbook_file "/etc/ssl/demoCA/demoCA.key"

openvpn_server "gw" do
  local_ip '192.168.67.10'
  port 1195
  proto "udp"
  dev_index 0
  ca "/etc/ssl/demoCA/demoCA.crt"
  cert "/etc/ssl/demoCA/demoCA.crt"
  key "/etc/ssl/demoCA/demoCA.key"
end

openbsd_interface "tun0" do
  inet  "10.7.30.10 255.255.255.0"
  inet6 "2001:db8:7:30::1 64"
  config "#{node['openvpn']['dir']}/gw.conf"
end

execute 'start tun0' do
  command 'sh /etc/netstart tun0'
  not_if '/sbin/ifconfig tun0'
end
