<!-- Heading  -->
## Pre reqs
* Recommended PC with 8GB Ram (can adjust spec to master 4gb, worker 1gb)
* Virtual box
* Vagrant

## Guide

1. Clone the repo locally and you should have a vagrant-k8s-cluster folder. Navigate into folder;

```
├── scripts/
│   ├── common.sh
│   ├── master.sh
│   └── worker.sh  <–––
├── Readme.md
├── spec.yaml
└── Vagrantfile
```

2. Edit spec file with your customizations

```
cluster_name: K8s Sandbox   ==> name of cluster & virtualbox group

# Adjust specs of machines
nodes:    
  master:
    cpu: 2
    memory: 4096    
  workers:      
    count: 2         ==> How many workers you want
    cpu: 2
    memory: 2048

```