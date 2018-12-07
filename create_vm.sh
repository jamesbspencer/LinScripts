#!/bin/bash
##Script to create a VM with virt-install.
##Requires virt-install to be installed. 
##Created by: James Spencer


name='repo'             #VM Name
type='linux'            #OS type linux or windows
variant='centos7.0'     #OS Variant win2k8,rhel7,centos7.0
mem='2048'              #Memory in MB
cpu='1'                 #Number of CPUs
dsize='25G'             #Disk Size in GB
dpath='/data1/data'     #Disk Location on NFS Mount
cdiso='CentOS-7-x86_64-DVD-1804.iso'    #CD ISO Name
cdpath='/data1/iso'     #CD ISO Path on NFS Mount
net='bridge0'

#Create the disk image because virt-install doesn't seem to thin provision
qemu-img create -f qcow2 $dpath/$name.qcow2 $dsize

#Create the VM and start the installer
virt-install \
--virt-type kvm \
--name $name \
--memory $mem \
--vcpus $cpu \
--os-type $type \
--os-variant $variant \
--disk path=$dpath/$name.qcow2 \
--cdrom $cdpath/$cdiso \
--network bridge=$net \
--graphics vnc \
--autostart
