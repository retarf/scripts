#!/bin/sh

# Script starts two virtual machines
# and start local tunnel over ssh to vms

VM_RUNNING='running'

inet="$i"

dom_name_01='node01'
dom_name_02='node02'
dom_hostname_01='node1'
dom_hostname_02='node2'

domains=( $dom_name_01 $dom_name_02 )
nodes=( $dom_hostname_01 $dom_hostname_02 )


# Start virtual machines
for dom in ${domains[@]}; do
    dom_status=`virsh list --all |grep $dom |awk '{ print $3 }'`
    if [ "$dom_status" == "$VM_RUNNING" ]; then
        continue
    fi
    virsh start $dom
done

# Start vm tunnel
for node in ${nodes[@]}; do
    while true; do
        # Check if node response on ssh port
        nc -z $node 22
        node_response="$?"
        if [ "$node_response" == "0" ]; then
            # Start tunnel to guest node on screen session
            # on port number with is taken from node name
            screen -d -m -S $node ssh -L $inet:${node: -1}:$node:22 root@$node
            break
        fi
        sleep 1
    done
done
