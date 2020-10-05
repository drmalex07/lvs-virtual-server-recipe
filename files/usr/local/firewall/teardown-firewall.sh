#!/bin/bash


iptables -tnat -D POSTROUTING -m comment --out-interface "${EXTERNAL_IFACE}" --source "${INTERNAL_NETWORK}" -j MASQUERADE \
   --comment "Masquerade packets from internal network (to ${EXTERNAL_IFACE})"

iptables -tnat -F PREROUTING

