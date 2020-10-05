# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

EXTERNAL_NETMASK = "255.255.255.0"
EXTERNAL_BRIDGE = "enp39s0" # interface on the host that will provide the bridged interface on the VM

inventory_file = 'hosts.yml'
inventory = YAML.load_file(inventory_file)
inventory_vars = inventory['all']['vars']
inventory_groups = inventory['all']['children']

internal_network = inventory_vars['internal_network']
internal_ipv4_virtual_address = inventory_vars['internal_ipv4_virtual_address']

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.synced_folder "./vagrant-data", "/vagrant", type: "rsync"

  inventory_groups['nat']['hosts'].keys.each do |machine_name|
    config.vm.define machine_name do |machine|
      h = inventory_groups['nat']['hosts'][machine_name]
      machine.vm.network "private_network", ip: h['ipv4_address']
      machine.vm.network "public_network", bridge: EXTERNAL_BRIDGE, ip: h['external_ipv4_address'], netmask: EXTERNAL_NETMASK 
      machine.vm.provider "virtualbox" do |vb|
        vb.name = h['fqdn']
        vb.memory = 512
      end    
    end
  end
  
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y python
  SHELL

  config.vm.provision "setup-basic", type: "ansible"  do |ansible|
    ansible.playbook = "play-1-setup-basic.yml"
    ansible.inventory_path = inventory_file
    ansible.become = true
    ansible.verbose = true
  end
  
  config.vm.provision "setup-mailer", type: "ansible"  do |ansible|
    ansible.playbook = "play-2-setup-mailer.yml"
    ansible.inventory_path = inventory_file
    ansible.become = true
    ansible.verbose = true
  end
 
  config.vm.provision "setup-virtual-server", type: "ansible"  do |ansible|
    ansible.playbook = "play-3-virtual-server.yml"
    ansible.inventory_path = inventory_file
    ansible.become = true
    ansible.verbose = true
  end
  
  #config.vm.provision "scratch-1", type: "ansible"  do |ansible|
  #  ansible.playbook = "scratch-1.yml"
  #  ansible.inventory_path = inventory_file
  #  ansible.become = true
  #  ansible.verbose = true
  #end

end
