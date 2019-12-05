# vim: set filetype=ruby:

VAGRANTFILE_API_VERSION = "2"

# by default, the cpu number of vm is 4.
cpu_number = ENV["VM_CPU_NUMBER"] || 4

# by default, the memory of vm is 4GB.
memory_limit = ENV["VM_MEMORY_LIMIT"] || 4096

# by default, the storage of vm is 64GB.
disk_quota = ENV["VM_DISK_QUOTA"] || "64GB"

# by default, the https_proxy is empty. just in case, the provision script
# need the https_proxy.
https_proxy = ENV["VM_HTTPS_PROXY"] || ""

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # based on offical ubuntu server 16.04 LTS (Xenial Xerus) builds
  config.vm.box = "ubuntu/xenial64"

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

  # vagrant plugin - vagrant-disksize
  #   used to add more disk quota for the vm since the dafault value is small
  #   ref: https://github.com/sprotheroe/vagrant-disksize
  if Vagrant.has_plugin?("vagrant-disksize")
    config.disksize.size = disk_quota
  end

  # setup package source
  config.vm.provision "shell", 
    :path => "build/pkg_mgmt.sh",
    :env => { :https_proxy => https_proxy }

  # change timezone into localtime
  config.vm.provision "shell", :path => "build/timezone.sh"

  # install tools
  config.vm.provision "shell",
    :path => "build/install_tools.sh",
    :env => { :https_proxy => https_proxy }

  # clone github projects
  config.vm.provision "shell",
    :path => "build/clone_github_projects.sh",
    :env => { :https_proxy => https_proxy }
end
