#!/bin/bash

set -euxo pipefail

config_path="/vagrant/configs"

echo "********* ABOUT TO JOIN !!!!!!!!!!!!!!!!! *********"
echo "********* ABOUT TO JOIN !!!!!!!!!!!!!!!!! *********"

# run join statement 
/bin/bash $config_path/join.sh -v

sudo -i -u vagrant bash << EOF
    NODENAME=$(hostname -s)
EOF

