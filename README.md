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

The following will build you a working Philbot appliance on an Ubuntu Vagrant VM. Assumptions:

* You have a Rackspace Cloudfiles account
* You want to use a Cloudfiles container called _{bucket}_
* You want your local share to reside at _/home/share/_
* You want the device to show up on your network as _{myappliance}_
* You want to login as _{user}_ with password _{password}_
* You're going to mount this with a Mac
* You want to Samba like it's 1999

Cargo-cult at your own risk. So first, there's bunch of spadework to be done (Note: where you see things in {braces}, you actually have fill in stuff, copy 'n' paste won't work):

```
sudo bash
apt-get update
apt-get -y install curl git redis-server samba avahi-daemon
useradd -s /bin/bash -G admin -m {user}
mkdir -p /home/share
chown nobody:nogroup /home/share
```

Paste this over _/etc/samba/smb.conf_:

```
[global]
  workgroup = {myappliance}
  security = user
  kernel oplocks = yes

[{myappliance}]
  comment = {myappliance}
  path = /home/share
  writeable = yes
  guest ok = no
```

and do:

```
echo "{password}
{password}" | smbpasswd -a -s {user}
smbpasswd -e {password}
```

Now paste this into _/etc/avahi/services/smb.service_:

```
<?xml version="1.0" standalone='no'?>
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
 <name replace-wildcards="yes">{myappliance}</name>
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

Restart samba and avahi (or just reboot the box) and you should now have a working samba server. It will advertise itself on yer network as _{my appliance}_, and you'll be able to connect as _{user}/{password}_ and drop some files on it.

Presuming this all works, then go create a Cloudfiles container called _{bucket}_ (using Cyberduck, the Web interface, magic spells, whatever), then configure the actual Philbot code:

```
sudo su - {user}
curl -sSL https://get.rvm.io | bash -s stable --ruby
source ~/.rvm/scripts/rvm
git clone https://github.com/theodi/philbot
cd philbot/
bundle install
```

Edit _conf/philbot.yaml_ so it looks like this:

```
provider:  Rackspace
username:  somerackspacelogin
api_key:   longstringoflettersandnumbers11
region:    lon
container: {bucket}
```

Then:

```
echo "SHARE=/home/share/" > .env
rvmsudo bundle exec foreman export -u {user} -a {user} upstart /etc/init
```

Now start the service with `service philbot start` (or bounce the box again) and the magic should begin to happen: open a view on your Cloudfiles container (Cyberduck, web browser, remote viewing, whatever you got), then drop some more files in the _{my appliance}_ share and they should start to appear in Cloudfiles.

##RasPi

##Gotchas

##Roadmap

###Auto-configuration

###Cold storage

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
