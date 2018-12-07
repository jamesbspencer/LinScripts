#!/bin/bash

##Script by: James Spencer
##Script requires novnc and websockify to be installed
##Script requires port 6080 to be open in the firewall



#Populate the array with the list of Vms
hosts=`virsh list --name`

#See if 1 has value.
if [ "$1" != "" ]; then
        #If 1 has value then see if it is also in the array.
        if [[ ${hosts[@]} =~ $1 ]]; then
                port=`virsh vncdisplay $1 | awk -F: '{print $2}'`
                echo $port
                echo "NoVNC will be started on http://192.168.77.42:6080"
                echo "Press CNTRL + C to stop"
                /bin/websockify --run-once --web=/usr/share/novnc 6080 127.0.0.1:59$port
        else
                #if 1 is not part of the array, nofiy the operator to try again.
                echo "$1 is not a valid host. Pick one:"
                echo $hosts
        fi
else
        #If 1 is empty, tell the operator to pick an item from the array.
        echo "Pick one:"
        echo $hosts
fi
