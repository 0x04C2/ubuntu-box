# vim: set filetype=ruby:

VAGRANTFILE_API_VERSION = "2"

# by default, the cpu number of vm is 4.
cpu_number = ENV["VM_CPU_NUMBER"] || 4

# by default, the memory of vm is 4GB.
memory_limit = ENV["VM_MEMORY_LIMIT"] || 4096

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # based on Official Ubuntu 18.04 LTS (Bionic Beaver) Daily Build
  config.vm.box = "ubuntu/bionic64"

  # provided by virtualbox
  #
  # - headless bootup
  # - 4 cpu number or the value by env VM_CPU_NUMBER
  # - 4GB memory or the value by env VM_MEMORY_LIMIT
  config.vm.provider "virtualbox" do |vb|
    vb.gui    = false
    vb.cpus   = cpu_number
    vb.memory = memory_limit
  end

  # setup package source
  config.vm.provision "shell", :path => "build/pkg_mgmt.sh"

  # change timezone into localtime
  config.vm.provision "shell", :path => "build/timezone.sh"

  # install tools
  config.vm.provision "shell", :path => "build/install_tools.sh"
end
