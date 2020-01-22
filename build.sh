#!/bin/bash
name="alstjr7375/typed"
version="1.4"
cpu_option="-nogpu -f Dockerfile.nongpu"

docker-build()
{
  local tag=$1
  option=$2
  if $no_cache; then
    docker build --no-cache --tag=${name}:${tag}${option} .
  else
    docker build --tag=${name}:${tag}${option} .
  fi
}

docker-push()
{
  local tag=$1
  local option=$2
  docker push ${name}:${tag}${option}
}

build()
{
  echo "===== Build Docker ====="
  local tag=$1
  if $build_all; then
    docker-build $tag
    docker-build $tag $cpu_option
  else
    source ./check.sh
    check-gpu
    if $gpu_detected ; then
      docker-build $tag
    else
      docker-build $tag $cpu_option
    fi
  fi
}

push()
{
  echo "===== Push Docker ====="
  local tag=$1
  if   $build_all; then
    docker-push $tag
    docker-push $tag $cpu_option
  elif $gpu_detected ; then
    docker-push $tag
  else
    docker-push $tag $cpu_option
  fi
}

execute()
{
  local func=$1
  if $do_latest; then
    $func $version
    $func latest
  else
    $func $version
  fi
}

main()
{
  build_all=false
  do_latest=false
  after_push=false
  no_cache=false
  while getopts "alpn" opt; do
    case $opt in
      a)
        echo "build all"
        build_all=true
        ;;
      l)
        echo "latest"
        do_latest=true
        ;;
      p)
        echo "build after push"
        after_push=true
        ;;
      n)
        echo "build with no cache"
        no_cache=true
        ;;
    esac
  done

  execute build
  if $after_push; then
    execute push
  fi
}

main $@
