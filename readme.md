# learning packer

docker builder with ansible provisioner
burrowed a lot from https://github.com/staticdev/linux-workstation-playbook
bonus: https://github.com/geerlingguy/mac-dev-playbook
https://github.com/geerlingguy/macos-virtualbox-vm

docker rmi $(docker images --filter "dangling=true" -q --no-trunc) -f
docker image ls --format "{{ .Size }}"