# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           |  host-c  |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/fabrizio-granelli/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of your project

## Design Requirements
- Hosts 1-a and 1-b are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively {{ HostsASubnetRequiredAddresses }} and {{ HostsBSubnetRequiredAddresses }} usable addresses
- Host 2-c is in a subnet (*Hub*) that needs to accommodate up to {{ HubSubnetRequiredAddresses }} usable addresses
- Host 2-c must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from Host-1-a and Host-1-b
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/fabrizio-granelli/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'. 
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner (fabrizio.granelli@unitn.it) that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/


# Design
- 435 adresses for host-A
- 371 adresses for host-B
- 348 adresses for host-C
- Host-c must run a docker image (dustnic82/nginx-test) that must be reachable by host-a and host-b
- No dynamic routing can be used
- Routes must be as generic as possible

## Network and subnet

![alt text](https://github.com/sabrina-mattuzzi/dncs-lab/blob/master/rete.JPG)

I divided the network in the image above in four different subnets:
- between router-1 and router-2

In thist subnet there are only router-1 and router-2, so I decided to use /30 to manage only 2 adresses (2<sup>32-30</sup>-2=2)

| NETWORK INTERFACE | DEVICE | IP ADDRESS | 
| :---: | :---: | :---:|
| enp0s9 |  router-1 | 10.1.1.1/30 | 
| enp0s9 | router-2 | 10.1.1.2/30 

- between router-1 and host-a

In thist subnet I have to manage 435 ip adresses, so I decided to use /23 (2<sup>32-23</sup>-2=510>435).
Host-a is connected to the same switch as host-b, to differentiate the two subnets I created two distinct VLANs. Host-a's subnet uses tag "2"

| NETWORK INTERFACE | DEVICE | IP ADDRESS | 
| :---: | :---: | :---:|
| enp0s8.2 |  router-1 | 192.168.0.1/23 | 
| enp0s8 | host-a | 192.168.0.2/23 

- between router-1 and host-b

In thist subnet I have to manage 371 ip adresses, so I decided to use /23 (2<sup>32-23</sup>-2=510>371). 
Host-b is connected to the same switch as host-a, to differentiate the two subnets I created two distinct VLANs. Host-b's subnet uses tag "3".

| NETWORK INTERFACE | DEVICE | IP ADDRESS | 
| :---: | :---: | :---:|
| enp0s8.3 |  router-1 | 192.168.2.1/23 | 
| enp0s8 | host-b | 192.168.2.2/23 

- between router-2 and host-c

In thist subnet I have to manage 348 ip adresses, so I decided to use /23 (2<sup>32-23</sup>-2=510>348)

| NETWORK INTERFACE | DEVICE | IP ADDRESS | 
| :---: | :---: | :---:|
| enp0s8 |  router-1 | 192.168.4.1/23 | 
| enp0s8 | host-b | 192.168.4.2/23

## Vagrantfile

I modified the Vagrantfile, changing the path on each device such as
```
 hostc.vm.provision "shell", path: "host-c.sh"
```
Also to put and run the docker-image it was necessary to increase the memory of the host-c from 256 MB to 512 MB.
```
vb.memory = 512
```

# Devices configuration

## Router-1

## Router-2

## Switch

## Host-a

## Host-b

## Host-c

