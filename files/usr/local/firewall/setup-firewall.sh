#!/bin/bash

set -e

test -n "${EXTERNAL_IFACE}"
test -n "${INTERNAL_NETWORK}" 

# Masq packets going to external network

iptables -tnat -A POSTROUTING -m comment \
  --out-interface "${EXTERNAL_IFACE}" --source "${INTERNAL_NETWORK}" -j MASQUERADE \
  --comment "Masquerade packets from internal network (to ${EXTERNAL_IFACE})"

# Forward TCP traffic for specific hosts of internal network

# DNAT_MAP is a space-separated list of <dport>:<internal-host>:<port>
for x in ${DNAT_MAP}; do 
    dport=${x%%:*}; 
    to=${x#*:}; 
    iptables -tnat -A PREROUTING -m tcp -p tcp \
       --in-interface "${EXTERNAL_IFACE}" --dport "${dport}" -j DNAT --to-destination "${to}"
done 

