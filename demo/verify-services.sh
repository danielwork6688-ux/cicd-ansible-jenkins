#!/usr/bin/env bash
set -euo pipefail

target_host="${TARGET_IP_ADDR:-20.212.9.18}"
ssh_key="${ANSIBLE_TARGET_KEY:-/home/azureuser/.ssh/ansible_target_key}"

echo "Build host checks"
systemctl is-active --quiet docker && echo "docker: active"
systemctl is-active --quiet jenkins && echo "jenkins: active"
curl -fsSI http://127.0.0.1:8080 >/dev/null && echo "jenkins endpoint: reachable"

echo
echo "Shared-services host checks: ${target_host}"
ssh -i "${ssh_key}" "azureuser@${target_host}" 'sudo systemctl is-active --quiet postgresql && echo "postgresql: active"'
ssh -i "${ssh_key}" "azureuser@${target_host}" 'sudo systemctl is-active --quiet sonarqube && echo "sonarqube: active"'
ssh -i "${ssh_key}" "azureuser@${target_host}" 'sudo systemctl is-active --quiet nexus && echo "nexus: active"'
ssh -i "${ssh_key}" "azureuser@${target_host}" 'curl -fsSI http://127.0.0.1:9000 >/dev/null && echo "sonarqube endpoint: reachable"'
ssh -i "${ssh_key}" "azureuser@${target_host}" 'curl -fsSI http://127.0.0.1:8081 >/dev/null && echo "nexus endpoint: reachable"'

