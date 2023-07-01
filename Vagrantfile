require "yaml"
build_spec = YAML.load_file "spec.yaml"


NA = build_spec["core_networking"]["network_address"].match(/^(\d{1,3}\.\d{1,3}\.\d{1,3}\.)(\d{1,3})$/)  #Network address - splift first 3 octects
NET_ADDR_OCTECT = NA.captures[0]  #network addr first 3 octects
MASTR_HOST_OCTECT = Integer(build_spec["core_networking"]["master_host_octect"])  #master node host/last octect
WRK_NODE_COUNT= build_spec["nodes"]["workers"]["count"]  # worker nodes count


Vagrant.configure("2") do |config|

  config.vm.provision "shell", env: { "NAO" => NET_ADDR_OCTECT, "IP_START" => MASTR_HOST_OCTECT, "WNC" => WRK_NODE_COUNT }, inline: <<-SHELL
    apt-get update -y
    echo "$NAO$((IP_START)) master" >> /etc/hosts
    for i in `seq 1 ${WNC}`; do
      echo "$NAO$((IP_START+i)) worker0${i}" >> /etc/hosts
    done
  SHELL

  #set vagrant box
  config.vm.box = build_spec["environment"]["vagrant_box"]  

  # create master
  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    # master.vm.network "private_network", ip: "$NET_ADDR_OCTECT$MASTR_HOST_OCTECT"
    master.vm.provider "virtualbox" do |vb|
      vb.cpus = build_spec["nodes"]["master"]["cpu"]
      vb.memory = build_spec["nodes"]["master"]["memory"]
    end

  end



end