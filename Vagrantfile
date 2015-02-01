# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "perforce.test"

  config.vm.provider "virtualbox" do |v, override|
    v.gui = false
    v.customize ["modifyvm", :id, "--memory", 2048]
  end

  config.vm.define "p4d", primary: true do |p4d|
    p4d.vm.provision "shell" do |s|
      s.path = "install.sh"
      s.args = ["p4", "p4d", "swarm"]
    end

    p4d.vm.network :forwarded_port, guest: 80, host: 8080
  end

  config.vm.define "jenkins", autostart: false do |jenkins|
    jenkins.vm.provision "shell" do |s|
      s.path = "install.sh"
      s.args = ["p4", "jenkins"]
    end

    jenkins.vm.network :forwarded_port, guest: 80, host: 8081
  end
end
