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
cookbook_file "/etc/ssl/demoCA/demoCA-client.crt"
cookbook_file "/etc/ssl/demoCA/demoCA-client.key"

openvpn_client "gw" do
  port 1195
  proto "udp"
  dev_index 0
  remote "192.168.67.10"
  ifconfig :databag
  ca "/etc/ssl/demoCA/demoCA.crt"
  cert "/etc/ssl/demoCA/demoCA-client.crt"
  key "/etc/ssl/demoCA/demoCA-client.key"
end
