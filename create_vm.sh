#!/bin/bash

name='repo'             #VM Name
type='linux'            #OS type linux or windows
variant='centos7.0'     #OS Variant win2k8,rhel7,centos7.0
mem='2048'              #Memory in MB
cpu='1'                 #Number of CPUs
dsize='100'             #Disk Size in GB
dpath='/data1/data'     #Disk Location on NFS Mount
cdiso='CentOS-7-x86_64-DVD-1804.iso'    #CD ISO Name
cdpath='/data1/iso'     #CD ISO Path on NFS Mount
net='bridge0'

virt-install \
--virt-type kvm \
--name $name \
--memory $mem \
--vcpus $cpu \
--os-type $type \
--os-variant $variant \
--disk path=$dpath/$name.qcow2,size=$dsize \
--cdrom $cdpath/$cdiso \
--network bridge=$net \
--autostart
