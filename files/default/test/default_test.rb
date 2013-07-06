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

describe_recipe 'openvpn::default' do
  it 'installs openvpn' do
    package('openvpn').must_be_installed
  end

  it 'creates /etc/openvpn' do
    file(node['openvpn']['dir']).must_exist
  end

  it 'starts openvpn' do
    assert_sh "pgrep openvpn"
  end

  it 'creates /etc/openvpn/dh.pem' do
    dh = file(node['openvpn']['ssl']['dh'])
    dh.must_exist
    dh.must_include 'BEGIN DH PARAMETERS'
  end
end
