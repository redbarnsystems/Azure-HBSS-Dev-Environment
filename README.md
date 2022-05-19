# Azure-HBSS-Dev-Environment

The Azure-HBSS-Dev-Environment repository contains a number of ARM templates to deploy a basic development environment consisting of networking representing a core site and two satelite sites within Azure.  This enables a capability to be rapidly deployed to test and develop new site-to-site capabilities.  It is left to the user to deploy individual VMs within each site's subnet(s) or expand the subnets as required.

## Architecture

The overarching architectural princple for the HBSS Dev environment is that individual virtual machines and subnets are isolated both from the wider internet and each other by default.  This means individual virtual machines cannot communicate with each other outside of their own subnet.

Four virtual networks are deployed by default.  The vNet-HBSS-DCC virtual network is designed to roughly replicate a main HQ network.  The network is partitioned into five initial subnets to segregate resources as required.

Two further vNets are deployed (vNet-HBSS-SITE01 and vNet-HBSS-SITE01) to represent more basic satelite sites/locations.  These each initially contain two subnets, a core subnet for site services and a DMZ for WAN facing services.  

Finally, the managment subnet (vNet-HBSS-MGMT) exists purely for management of the environment and the VMs within it.  This managment subnet is peered with each of the other site subnets and traffic to/from it is unrestricted allowing virtual machines on the management subnet to RDP/SSH to any other VM in the environment.

Individual virtual machines do not by default have any Network Security Groups (NSGs) associated with them.  All subnets however are restricted by the same common NSG (nsg-hbss) which provides a single central location to control traffic flow across the network.

Please see the overview diagram below.

![HBSS Dev Environment Architecture](images/HBSS-Networking.png)

Finally, management of the environment is initially performed via a web portal running on the ragateway.mgmt.hbss.local virtual machine. This is the only virtual machine in the environment with wider internet access and consquently the only virtual machine with its own NSG limiting traffic from the wider internet to ssl web encrypted traffic on port 8443.  If further lock down is required, access to the VM can be additionally restricted using Azure Just in Time (JIT) access meaning all traffic is blocked until specific ports are opened to individual IPs as required.

The ragateway VM runs Apache Guacamole enabling web based RDP or SSH sessions to be defined for each of the VMs on the internal environment.  In addition, if configured, file transfer to the internal VMs can be performed from the same web portal. Apache Guacamole performs all of the functionality of Azure Bastion and more for out of band access to airgapped virtual machines. It is however significantly cheaper to run and can be shutdown when not in use unlike Bastion which needs to be deleted.

Finally, AzureBastionSubnet and GatewaySubnet subnets have been created on the managment vNet ready to deploy Azure Baston or Gateway devices should they be required in the future.