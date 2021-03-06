docker-install()
{
  echo "========== Docker Install =========="
  echo "Check Docker Installed.."
  if type docker &>/dev/null; then
    echo "Docker Already Installed."
  else
    echo "Installing Docker..."
    sudo wget -qO- https://get.docker.com/ | sh
    echo "Setting Docker..."
    sudo docker rm `sudo docker ps -aq`
    sudo docker rmi hello-world
    echo "Now, Docker Installed."

    echo "Add Docker Usergroup..."
    sudo usermod -aG docker $USER
  fi
}

nvidia-docker-install()
{
  echo "========== Nvidia Docker Install =========="
  echo "Check Nvidia Docker Installed.."
  if type nvidia-docker &>/dev/null; then
    echo "Docker Already Installed."
  else
    echo "Installing Nvidia Docker..."
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

    sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
    echo "Setting Nvidia Docker..."
    sudo systemctl restart docker
    echo "Now, Nvidia Docker Installed."
  fi
}

pull-image()
{
  echo "========== Download Typed Docker =========="
  local tag=$1
  sudo docker pull alstjr7375/typed:${tag}
}

set-file()
{
  local file=$1
  local tag=$2
  echo "-------"
  echo "Set $file !!"
  echo ""
  if [ -e $file ]; then
    echo ""
  else
    echo "$file not found."
    touch $file
    echo "$file is created"
    echo "alias dpython='docker run --rm -i -t -v \$(pwd):/ai  alstjr7375/typed:${tag} python'" >> $file
    echo ""
  fi
}

set-alias()
{
  echo "========== Set Alias =========="
  local tag=$1
  set-file ~/.bashrc $tag
  set-file ~/.zshrc  $tag
}

main()
{
  docker-install
  source ./check.sh
  check-gpu
  if $gpu_detected ; then
    nvidia-docker-install
    tag=latest
  else
    tag=latest-nogpu
  fi

  pull-image $tag
  set-alias  $tag
}

main
