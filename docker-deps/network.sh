#!/bin/bash

tc qdisc del dev eth0 root
tc qdisc add dev eth0 root handle 1: prio
tc qdisc add dev eth0 parent 1:3 handle 30: tbf rate 10000kbps buffer 1600 limit  3000
tc qdisc add dev eth0 parent 30:1 handle 31: netem delay 250ms 75ms 25% loss 15% duplicate .05% corrupt 0.1% reorder 2% 50%

tc filter add dev eth0 protocol ip parent 1:0 prio 3 u32 match ip dst 172.67.149.246/32 flowid 1:3
tc filter add dev eth0 protocol ip parent 1:0 prio 3 u32 match ip dst 104.21.29.232/32 flowid 1:3

