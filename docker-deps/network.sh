#!/bin/bash

IFACE="${IFACE:-eth0}"

echo "Creating horrible network conditions on network interface: ${IFACE}"

tc qdisc del dev "${IFACE}" root
tc qdisc add dev "${IFACE}" root handle 1: prio
tc qdisc add dev "${IFACE}" parent 1:3 handle 30: tbf rate 10000kbps buffer 1600 limit  3000
tc qdisc add dev "${IFACE}" parent 30:1 handle 31: netem delay 250ms 75ms 25% loss 15% duplicate .05% corrupt 0.1% reorder 2% 50%


if [ -n "${1}" ]; then
    for ip in $(dig +short "${1}"); do
        tc filter add dev "${IFACE}" protocol ip parent 1:0 prio 3 u32 match ip dst "${ip}"/32 flowid 1:3
    done
    tc filter add dev "${IFACE}" protocol ip parent 1:0 prio 3 u32 match ip dst "${1}"/32 flowid 1:3 || true
fi

tc filter add dev "${IFACE}" protocol ip parent 1:0 prio 3 u32 match ip dst 172.67.149.246/32 flowid 1:3
tc filter add dev "${IFACE}" protocol ip parent 1:0 prio 3 u32 match ip dst 104.21.29.232/32 flowid 1:3
