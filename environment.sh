# Docker Install
sudo wget -qO- https://get.docker.com/ | sh
sudo docker rm `sudo docker ps -aq`
sudo docker rmi hello-world

# Nvidia Docker Install
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker

# Download Typed Docker
docker pull alstjr7375/typed
