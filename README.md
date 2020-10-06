# README - Setup LVS virtual server

This recipe sets up an LVS-NAT virtual server (actually, a pair of servers in a highly-available mode) using `keepalived`.

In this setup, we have an external and an internal network. The external is the one facing the end-user of a service, while the internal interacts with the backend services (the `real` servers in LVS terminology). Each of these networks have a virtual IP (VIP): for the external network the VIP is the endpoint that users know to access services, while on the internal network the VIP is the gateway used by backend servers (note that in order for LVS-NAT to work, the return path for a packet must be the same, so we need to configure those gateways!).

On failover, both VIPs switch from master machine to the backup machine (this group of VIPs is the `VRRP` sync group).

## 1. Prerequisites

Copy `hosts.yml.example` to `hosts.yml` and configure this inventory file.

Create secret files under `secret/smtp/user/USERNAME` and `secrets/smtp/ca.pem`

## 2. Setup

The recipe is basicly a collection of Ansible playbooks. They can be either run directly (using `ansible-playbook`) or under Vagrant provisioning.

### 2.1 Setup with Vagrant

You need to edit `Vagrant` file to 

The Vagrant file sets up 2 machines `master` and `backup`:

    vagrant up

You can only run a certain phase of provisioning, one of: `setup-basic`, `setup-mailer`, `setup-virtual-server`. For example for running `setup-mailer` provisioning:

    vagrant provision --provision-with setup-mailer

### 2.2 Setup with plain Ansible

If the machine infrastructure is allready setup, you can directly run the Ansible playbooks. For example:

    ansible-playbook -i hosts.yml --become -v play-1-setup-basic.yml

