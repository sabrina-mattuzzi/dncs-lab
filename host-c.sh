export DEBIAN_FRONTEND=noninteractive

#Startup commands go here

#Network interface config
sudo ip addr add 192.168.4.2/23 dev enp0s8
sudo ip link set dev enp0s8 up

#Defaul gateway set up
sudo ip route add 10.1.1.0/30 via 192.168.4.1
sudo ip route add 192.168.0.0/23 via 192.168.4.1
sudo ip route add 192.168.2.0/23 via 192.168.4.1

sudo apt-get update
#Install and run Docker.io
sudo apt -y install docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo docker pull dustnic82/nginx-test
sudo docker run --name nginx -p 80:80 -d dustnic82/nginx-test