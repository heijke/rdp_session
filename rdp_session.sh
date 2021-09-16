#!/bin/bash

case $1 in 
	remote-connect)
	printf "Connecting to the remote desktop...\n"
	xfreerdp /u:"user" /p:"password" /v:$2 /frame-ack:9 +clipboard /geometry /auto-reconnect-max-retries:5 +offscreen-cache +window-drag +bitmap-cache /dynamic-resolution &
	;;
	vm-connect)
	if [[ `virsh net-list | grep default | awk '{print $2}'` != "active" ]]; then 
		virsh net-start default
	fi
	until [[ "`virsh net-list | grep default | awk '{print $2}'`" == "active" && "`virsh list | grep RDPWindows | awk '{print $3}'`" == "running" ]]; do
		virsh start RDPWindows
		printf "Waiting for the virtual machine to start...\n"
		sleep 5
	done
	case $# in
	1)
	printf "Connecting to the remote desktop...\n"
	xfreerdp /u:"user" /p:"password" /v:$2 /frame-ack:9 /multimon:force +clipboard /geometry /auto-reconnect-max-retries:5 +offscreen-cache +window-drag +bitmap-cache >/dev/null 2>/dev/null &
	;;
	2)
	printf "Connecting to the remote desktop APP: $3...\n"
	xfreerdp /u:"user" /p:"password" /v:$2 /app:"$3" /frame-ack:9 /multimon:force +clipboard /f /geometry /auto-reconnect-max-retries:5 +offscreen-cache +window-drag +bitmap-cache 
	;;
	esac
	;;
	vm-disconnect)
	virsh shutdown RDPWindows --mode acpi 
	while [[ `virsh list | grep RDPWindows | awk '{print $3}'` == "running" ]]; do
	printf "Waiting for the virtual machine to stop...\n"
	sleep 10
	done
	printf "Virtual machine stopped...\n"
	virsh net-destroy default
	;;
	*)
	printf "Connect to remote machine or run applications from RDP-vm\nSimilar to winapps\nUsage: rdp_session.sh {vm-connect|vm-disconnect} <IP ADDRESS> [APPLICATION]\nrdp_session.sh remote-connect <IP ADDRESS>"
	;;
esac
