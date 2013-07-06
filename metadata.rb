maintainer       "TKNetworks"
maintainer_email "nabeken@tknetworks.org"
license          "Apache 2.0"
description      "Installs/Configures openvpn"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
name             "openvpn"

%w{openbsd chef-openbsd}.each do |os|
  depends os
end
