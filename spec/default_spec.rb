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

describe 'openvpn::default' do
  before(:each) { ::File.stub(:exists?).and_call_original }

  # tests for OpenBSD/FreeBSD/Debian
  let(:dir) {
    {
      'openbsd' => '/etc/openvpn',
      'freebsd' => '/usr/local/etc/openvpn',
      'debian'  => '/etc/openvpn',
    }
  }
  %w{openbsd freebsd debian}.each do |os|
    context "on #{os}" do
      include_context os
      it 'should create openvpn directory' do
        chef_run.converge 'openvpn::default'
        expect(chef_run).to create_directory dir[os]
      end

      it 'should generate dh params' do
        ::File.stub(:exists?).with("#{dir[os]}/dh.pem").and_return(false)
        chef_run.converge 'openvpn::default'
        expect(chef_run).to execute_command(
          "openssl dhparam -out %s %s" % ["#{dir[os]}/dh.pem", chef_run.node['openvpn']['ssl']['dh_bit']])
      end
    end
  end
end
