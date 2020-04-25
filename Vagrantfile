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

  # provided by virtualbox
  #
  # - headless bootup
  # - 4 cpu number or the value by env VM_CPU_NUMBER
  # - 4GB memory or the value by env VM_MEMORY_LIMIT
  config.vm.provider "virtualbox" do |vb|
    # based on offical ubuntu server 18.04 (Bionic Beaver) builds
    config.vm.box = "ubuntu/bionic64"

    vb.gui    = false
    vb.cpus   = cpu_number
    vb.memory = memory_limit

    # vagrant plugin - vagrant-disksize
    #   used to add more disk quota for the vm since the dafault value is small
    #   ref: https://github.com/sprotheroe/vagrant-disksize
    if Vagrant.has_plugin?("vagrant-disksize")
      config.disksize.size = disk_quota
    end
  end

  # provided by vmware_fusion
  #
  # - headless bootup
  # - 4 cpu number or the value by env VM_CPU_NUMBER
  # - 4GB memory or the value by env VM_MEMORY_LIMIT
  #
  #
  # NOTE: Need to setup vagrant-vmware_fusion plugin
  #
  # 1. vagrant plugin install vagrant-vmware-desktop
  #
  # 2. vagrant plugin license vagrant-vmware-desktop ~/license.lic
  #
  config.vm.provider "vmware_fusion" do |vmware_fusion|
    # from hashicorp offical ubuntu server 18.04 (Bionic Beaver) builds
    config.vm.box = "hashicorp/bionic64"

    vmware_fusion.gui             = false
    vmware_fusion.vmx["memsize"]  = memory_limit
    vmware_fusion.vmx["numvcpus"] = cpu_number

    # enable VT-X
    vmware_fusion.vmx["vhv.enable"] = "TRUE"
  end

  # setup package source
  config.vm.provision "shell", 
    :path => "build/pkg_mgmt.sh",
    :env => { :https_proxy => https_proxy, :http_proxy => https_proxy }

  # change timezone into localtime
  config.vm.provision "shell", :path => "build/timezone.sh"

  # install tools
  config.vm.provision "shell",
    :path => "build/install_tools.sh",
    :env => { :https_proxy => https_proxy, :http_proxy => https_proxy }

  # clone github projects
  config.vm.provision "shell",
    :path => "build/clone_github_projects.sh",
    :env => { :https_proxy => https_proxy, :http_proxy => https_proxy }
end
