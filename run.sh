#!/bin/bash


find_available_port() {
    local port
    for port in {8001..8100}; do
        if ! lsof -i:$port >/dev/null 2>&1; then
            echo $port
            return
        fi
    done
    echo "No available ports found" >&2
    exit 1
}

run_container() {
    local build_path=$1
    local container_name=$2
    local image_name=$3
    
    local port=$(find_available_port)
    
    docker build -t $image_name $build_path
    docker run -d -p $port:8000 --name $container_name $image_name
    
    echo "$container_name is running on port $port"
    
    echo "$container_name:$port" >> /etc/nginx/ports.conf
}

run_container "/path/to/your/project" "your_container_name" "your_image_name"
