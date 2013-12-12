[![Build Status](https://travis-ci.org/theodi/philbot.png?branch=master)](https://travis-ci.org/theodi/philbot)
[![Gem Version](https://badge.fury.io/rb/philbot.png)](http://badge.fury.io/rb/philbot)
[![Code Climate](https://codeclimate.com/github/theodi/philbot.png)](https://codeclimate.com/github/theodi/philbot)
[![Coverage Status](https://coveralls.io/repos/theodi/philbot/badge.png)](https://coveralls.io/r/theodi/philbot)
[![Dependency Status](https://gemnasium.com/theodi/philbot.png)](https://gemnasium.com/theodi/philbot)
[![License](http://img.shields.io/license/mit.png?color=green)](http://theodi.mit-license.org/)
[![Things Cleaned](http://img.shields.io/things%20cleaned/all.png?color=green)](http://hyperboleandahalf.blogspot.co.uk/2010/06/this-is-why-ill-never-be-adult.html)

#Philbot

_Simple Cloudfiles client_

Imagine [one of these](http://aws.amazon.com/storagegateway/), but for Rackspace Cloudfiles

##Using it

_I copy and paste things I find on the Internet until it works_

The following will build you a working Philbot appliance on an Ubuntu Vagrant VM. Assumptions:

* You want your local share to reside at _/home/share/_
* You want the device to be show up on your network as _philbot_
* You want to login as _philbot_ with password _philbot_

Cargo-cult at your own risk:

```
sudo apt-get update
sudo apt-get -y install curl git redis-server samba avahi-daemon
sudo useradd -s /bin/bash -G admin -m philbot
sudo su - philbot

curl -sSL https://get.rvm.io | bash -s stable --ruby
source ~/.rvm/scripts/rvm
git clone https://github.com/theodi/philbot
cd philbot/
bundle install
exit

sudo bash
mkdir -p /home/share
chown nobody:nogroup /home/share
```

Paste this over _/etc/samba/smb.conf_:

```
[global]
  workgroup = filbot
  security = user
  kernel oplocks = yes

[philbot]
  comment = philbot
  path = /home/share
  writeable = yes
  guest ok = no
```

and do:

```
echo "philbot
philbot" | smbpasswd -a -s philbot
smbpasswd -e philbot
```

Now paste this into _/etc/avahi/services/smb.service_:

```
<?xml version="1.0" standalone='no'?>
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
 <name replace-wildcards="yes">philbot</name>
 <service>
   <type>_smb._tcp</type>
   <port>445</port>
 </service>
 <service>
   <type>_device-info._tcp</type>
   <port>0</port>
   <txt-record>model=RackMac</txt-record>
 </service>
</service-group>
```



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
