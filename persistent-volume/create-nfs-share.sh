#!/bin/bash 

for vol in $(seq 1 100)
do
pv=pv$vol   
mkdir -p /exports/$pv
chown -R nfsnobody:nfsnobody /exports/$pv 
chmod -R 755 /exports/$pv
echo "/exports/$pv *(rw,root_squash)" >> /etc/exports.d/openshift-userpvs.exports
done

exportfs -r
