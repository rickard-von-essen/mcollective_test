# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

$bridge_if ||= 'en1: USB Ethernet'
$ncpus ||= '2'
$memsize ||= '512'

# Use r10k to install puppet modules.
#
# gem install r10k
# gem install puppet
# PUPPETFILE_DIR=external_modules r10k puppetfile install
#
# vagrant up --no-provision
# vagrant provision
#

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "rickard-von-essen/opscode_centos-6.5"

  #config.vm.network :public_network, :bridge => $bridge_if

  config.vm.provider :parallels do |prl|
    prl.customize ["set", :id, "--memsize", $memsize]
    prl.customize ["set", :id, "--cpus", $ncpus]
    prl.customize ["set", :id, "--on-window-close", "keep-running"]
  end

  config.puppet_install.puppet_version = '3.4.3'

  config.vm.provision "puppet" do |puppet|
    puppet.manifest_file  = 'default.pp'
    puppet.module_path = [ 'external_modules', 'modules' ]
  end

  config.vm.define 'middleware' do |machine|
    machine.vm.hostname = 'middleware'
    machine.vm.network :private_network, ip: "172.16.0.2"
  end

  config.vm.define 'server' do |machine|
    machine.vm.hostname = 'server'
    machine.vm.network :private_network, ip: "172.16.0.3"
  end

  config.vm.define 'client' do |machine|
    machine.vm.hostname = 'client'
    machine.vm.network :private_network, ip: "172.16.0.4"
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
  end

end
