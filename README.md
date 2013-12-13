[![Build Status](https://travis-ci.org/theodi/philbot.png?branch=master)](https://travis-ci.org/theodi/philbot)
[![Gem Version](https://badge.fury.io/rb/philbot.png)](http://badge.fury.io/rb/philbot)
[![Code Climate](https://codeclimate.com/github/theodi/philbot.png)](https://codeclimate.com/github/theodi/philbot)
[![Coverage Status](https://coveralls.io/repos/theodi/philbot/badge.png)](https://coveralls.io/r/theodi/philbot)
[![Dependency Status](https://gemnasium.com/theodi/philbot.png)](https://gemnasium.com/theodi/philbot)
[![License](http://img.shields.io/license/mit.png?color=green)](http://theodi.mit-license.org/)
[![Things Cleaned](http://img.shields.io/things%20cleaned/all.png?color=green)](http://hyperboleandahalf.blogspot.co.uk/2010/06/this-is-why-ill-never-be-adult.html)

#Philbot

_Simple Cloudfiles client_

Like an [Amazon Storage Gateway](http://aws.amazon.com/storagegateway/), but for Rackspace Cloudfiles. It shows up on your network, you drop your files on it, they find their way to the Cloud.

##Using it

The following will build you a working Philbot appliance on an Ubuntu Precise Vagrant VM. Assumptions:

* You have a Rackspace Cloudfiles account
* You want to use a Cloudfiles container called _{bucket}_
* You want your local share to reside at _/home/share/_
* You want the device to show up on your network as _{myappliance}_
* You want to login as _{user}_ with password _{password}_
* You're going to mount this with a Mac
* You want to [Samba](http://www.samba.org/) like it's 1999

Cargo-cult at your own risk. So first, there's bunch of spadework to be done (Note: where you see things in {braces}, you actually have fill in stuff, copy 'n' paste will lead to horrible consequences):

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

Now start the service with `service philbot start` (or bounce the box again) and the magic should begin to happen: open a view on your Cloudfiles container (Cyberduck, web browser, remote viewing, whatever you got), then drop some more files in the _{my appliance}_ share and they should start to appear in Cloudfiles. Delete things locally, and they should start to be removed from Cloudfiles.

You are now Philbot-compliant.

##Roadmap

We have plans for at least a couple of new features:

###Auto-configuration

All Philbot really does is watch a directory (using the excellent [Listen](https://github.com/guard/listen) gem) for changes, and then queues jobs. So how about something like this:

* We run a second share, containing (initially) a dummy config file
* We mount the device over the network and edit this dummy file, filling in our actual Rackspace credentials
* Philbot notices this change (because this is what he does) and places the file in the correct location
* Suddenly, everything works

There is already code to support this, but it didn't survive first contact with the Real World due to some encoding thing. This is going to get done, though.


###Cold storage

At present, the Cloudfiles container stays in sync with the local storage. This is fine for now, but eventually even our 2TB USB drive is going to get full up. So here's the plan:

* When we drop a (empty) file called _freeze_ or something into a local directory, that directory gets deleted locally _but the files remain at the other end_
* We have some kind of index file at the root of the Cloudfiles container containing a list of frozen projects, which we can edit in order to unfreeze things (if this sounds a bit vague, that'll be because we've not really thought this but through yet, but it seems sensible)

##Raspberry Pi

When we were designing this, the target was always to put it onto a Raspberry Pi. We have this running right now on a Pi in the [ODI office](http://theodi.org/360s/Office/office.html), connected to a 2TB external USB drive, which gives us a self-contained Cloudfiles appliance for less than a hundred quid!

This path, however, is beset by bandits - Raspbian is based on Debian, which means:

####No Upstart, because ${REASONS}

I eventually gave up on attempting to get Foreman to do the Right Thing with things-that-are-not-Upstart (life is short, ya know?), put on the bamboo headphones and pasted this at the bottom of _/etc/inittab_:

```
PH01:4:respawn:/bin/su - philbot -c 'cd /home/philbot/philbot;export PORT=5000;bundle exec ruby bin/philbot /mnt/usb >> /var/log/philbot/philbot-1.log 2>&1'
```

which seems to work.

####_smbpasswd_ not part of Samba install, also because ${REASONS}

Not a big deal, but potentially frustrating. This command will fix it

```
sudo apt-get install samba-common-bin
```

and now you can add Samba users.

###RasPi image

The eventual plan is to publish a Raspbian-based SD-Card image which will work out a bunch o' stuff, present itself for auto-configuration, and then Just Work.  

##Issues

Are [here](https://github.com/theodi/philbot/issues/new). You got ideas, we wanna hear 'em.

## Contributing

We want your pull-requests! Take a fork, clone it and run the test suite (we use [Guard](https://github.com/guard/guard) for Super-Awesome Continuous Testing)

```
bundle install
bundle exec guard
```

(Note: this will intermittently fail because testing asynchronous things is hard. Hmm, maybe you can help me fix this, too?)

Then write some cukes and some code, and send us a PR!

##License

[MIT](http://theodi.mit-license.org/)
