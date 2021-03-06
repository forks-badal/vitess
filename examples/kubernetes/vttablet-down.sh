#!/bin/bash

# This is an example script that tears down the vttablet pods started by
# vttablet-up.sh.

set -e

script_root=`dirname "${BASH_SOURCE}"`
source $script_root/env.sh

server=$(get_vtctld_addr)

# Delete the pods for all shards
cell='test'
keyspace='test_keyspace'
SHARDS=${SHARDS:-'0'}
TABLETS_PER_SHARD=${TABLETS_PER_SHARD:-5}
UID_BASE=${UID_BASE:-100}

num_shards=`echo $SHARDS | tr "," " " | wc -w`
uid_base=$UID_BASE

for shard in `seq 1 $num_shards`; do
  for uid_index in `seq 0 $(($TABLETS_PER_SHARD-1))`; do
    uid=$[$uid_base + $uid_index]
    printf -v alias '%s-%010d' $cell $uid

    if [ -n "$server" ]; then
      echo "Removing tablet $alias from Vitess topology..."
      vtctlclient -server $server ScrapTablet -force $alias
      vtctlclient -server $server DeleteTablet $alias
    fi

    echo "Deleting pod for tablet $alias..."
    $KUBECTL delete pod vttablet-$uid
  done
  let uid_base=uid_base+100
done
