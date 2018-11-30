#!/bin/bash 

sizes=(512Mi 1Gi 2Gi)

si=0
for vol in $(seq 1 100)
do
   size=${sizes[$si]}
   pv=pv$vol
  
   sed s/%pv/$pv/g pv-template.yml | sed s/%size/$size/g | oc create -f -

   si=$(($si+1))
   [[ $si -ge 3 ]] && si=0
done