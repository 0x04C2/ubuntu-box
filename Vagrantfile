# vim: set filetype=ruby:

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # based on offical ubuntu server 16.04 LTS (Xenial Xerus) builds
  config.vm.box = "ubuntu/xenial64"

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

  # install tools
  #
  # NOTE: privileged(false) means run scripts as vagrant, not root.
  config.vm.provision "shell",
    :path       => "build/install_tools.sh",
    :privileged => false
end
