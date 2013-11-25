# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.network :public_network

#  config.vm.provision :chef_solo do |chef|
#    chef.cookbooks_path = "cookbooks"
#    chef.data_bags_path = "data_bags"
#    chef.add_recipe "git"
#    chef.add_recipe "rvm"
#    chef.add_recipe "samba"

    # You may also specify custom JSON attributes:
#    chef.json = { :mysql_password => "foo" }
#  end
end
