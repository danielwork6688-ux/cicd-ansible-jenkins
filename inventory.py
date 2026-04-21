#!/usr/bin/env python3
import json
import os

CONTROL_IP = os.environ.get("CONTROL_IP_ADDR", "127.0.0.1")
TARGET_IP = os.environ.get("TARGET_IP_ADDR", "20.212.9.18")

inventory = {
    "build_servers": {
        "hosts": [CONTROL_IP],
        "vars": {
            "ansible_connection": "local",
            "ansible_user": "azureuser",
            "ansible_python_interpreter": "/usr/bin/python3"
        }
    },
    "shared_services": {
        "hosts": [TARGET_IP],
        "vars": {
            "ansible_user": "azureuser",
            "ansible_python_interpreter": "/usr/bin/python3",
            "ansible_become": True,
            "ansible_ssh_private_key_file": "/home/azureuser/.ssh/ansible_target_key",
        }
    }
}

print(json.dumps(inventory, indent=2))