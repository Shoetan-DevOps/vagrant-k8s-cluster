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
  
  config.vm.provision "shell",
    env: {
      "DNS_SERVERS" => build_spec["core_networking"]["dns_servers"].join(" "),
      "KUBERNETES_VERSION" => build_spec["environment"]["kubernetes"],
      "OS" => build_spec["environment"]["os"]
    },
      path: "scripts/common.sh"

  #set vagrant box
  config.vm.box = build_spec["environment"]["vagrant_box"]  

  # create master
  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "#{NET_ADDR_OCTECT}#{MASTR_HOST_OCTECT}"
    master.vm.provider "virtualbox" do |vb|
      vb.cpus = build_spec["nodes"]["master"]["cpu"]
      vb.memory = build_spec["nodes"]["master"]["memory"]
      vb.customize ["modifyvm", :id, "--groups", ( build_spec["cluster_name"] ? "/" + build_spec["cluster_name"] : "/Sandbox-Cluster" )]
    end

    # master.vm.provision "shell",
    # env: {
    #   "DNS_SERVERS" => build_spec["core_networking"]["dns_servers"].join(" "),
    #   "KUBERNETES_VERSION" => build_spec["environment"]["kubernetes"],
    #   "OS" => build_spec["environment"]["os"]
    # },
    #   path: "scripts/common.sh"

    master.vm.provision "shell",
      env: {
        "CALICO_VERSION" => build_spec["environment"]["calico"],
        "MASTER_IP" => "#{NET_ADDR_OCTECT}#{MASTR_HOST_OCTECT}",
        "POD_CIDR" => build_spec["core_networking"]["pod_cidr"],
        "SERVICE_CIDR" => build_spec["core_networking"]["service_cidr"]
      },
      path: "scripts/master.sh"
  end

  # create worker
  (1..WRK_NODE_COUNT).each do |i|
    
    config.vm.define "worker#{i}" do |node|
      node.vm.hostname = "worker#{i}"
      node.vm.network "private_network", ip: NET_ADDR_OCTECT + "#{MASTR_HOST_OCTECT + i}"
      node.vm.provider "virtualbox" do |vb|
        vb.cpus = build_spec["nodes"]["workers"]["cpu"]
        vb.memory = build_spec["nodes"]["workers"]["memory"]
        vb.customize ["modifyvm", :id, "--groups", ( build_spec["cluster_name"] ? "/" + build_spec["cluster_name"] : "/Sandbox-Cluster" )]
      end
      node.vm.provision "shell", path: "scripts/worker.sh"
    end

  end

end