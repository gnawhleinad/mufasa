# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |v, override|
    v.gui = false
    v.customize ["modifyvm", :id, "--memory", 2048]
  end

  config.vm.define "p4d", primary: true do |p4d|
    p4d.vm.hostname = "p4d.test"

    p4d.vm.provision "shell" do |s|
      s.path = "install.sh"
      s.args = ["avahi", "p4", "p4d", "swarm"]
    end

    p4d.vm.network :forwarded_port, guest: 1666, host: 1666
    p4d.vm.network :forwarded_port, guest: 80, host: 8080
  end

  config.vm.define "jenkins", autostart: false do |jenkins|
    jenkins.vm.hostname = "jenkins.test"

    jenkins.vm.provision "shell" do |s|
      s.path = "install.sh"
      s.args = ["avahi", "p4", "jenkins", "dearsimba"]
    end

    jenkins.vm.network :forwarded_port, guest: 8080, host: 8081
  end

  config.vm.network :private_network, type: "dhcp"
end
