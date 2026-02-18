SHELL := /usr/bin/env bash
ANSIBLE_ARGS ?= $(if $(filter Linux,$(shell uname -s)),--ask-become-pass,)
CHEZMOI_SOURCE ?= ./chezmoi

.PHONY: setup apply ansible collections diff status

setup: collections ansible apply

collections:
	ansible-galaxy collection install -r ansible/collections/requirements.yml

ansible:
	ANSIBLE_CONFIG=ansible/ansible.cfg ANSIBLE_ROLES_PATH=ansible/roles ansible-playbook $(ANSIBLE_ARGS) -i ansible/inventories/local/hosts.yml ansible/playbooks/bootstrap.yml

apply:
	chezmoi apply --source $(CHEZMOI_SOURCE)

diff:
	chezmoi diff --source $(CHEZMOI_SOURCE)

status:
	chezmoi status --source $(CHEZMOI_SOURCE)
diff:
	chezmoi diff --source ./chezmoi
