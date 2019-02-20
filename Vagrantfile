# vim: set filetype=ruby:

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # based on Official Ubuntu 18.04 LTS (Bionic Beaver) Daily Build
  config.vm.box = "ubuntu/bionic64"

  # provided by virtualbox
  #
  # - headless bootup
  # - 4 cpu number
  # - 4GB memory
  config.vm.provider "virtualbox" do |vb|
    vb.gui    = false
    vb.cpus   = 4
    vb.memory = 4096
  end

  # setup package source
  config.vm.provision "shell", :path => "build/pkg_mgmt.sh"

  # change timezone into localtime
  config.vm.provision "shell", :path => "build/timezone.sh"

  # install tools
  config.vm.provision "shell", :path => "build/install_tools.sh"
end
