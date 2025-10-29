# 🧩 Apps Repository

This repository contains modular applications managed via **Ansible**, **Docker Compose**, and **custom Docker images**.
Each app resides in its own directory under `apps/`, with subfolders for automation, deployment, and build files.



## 📁 Repository Structure

<!-- APPS_TREE_START -->
<!-- APPS_TREE_END -->

## 📦 App Overview

<!-- APPS_TABLE_START -->
| App | Ansible | Compose | Image | Last Commit |
| --- | --- | --- | --- | --- |
| common | ✅ |  |  | 2025-10-29 |
| mtu_switchtool | ✅ | ✅ |  | 2025-10-29 |
| netbox |  | ✅ |  | 2025-10-29 |
| pg_backup | ✅ | ✅ |  | 2025-10-29 |
| radarr |  |  | ✅ | 2025-10-29 |
| sonarr |  |  | ✅ | 2025-10-29 |
| traefik | ✅ | ✅ |  | 2025-10-29 |
| traefikator |  |  | ✅ | 2025-10-29 |
| zabbix-proxy | ✅ | ✅ |  | 2025-10-29 |
| zabbix-server | ✅ | ✅ |  | 2025-10-29 |
| zabbix-web | ✅ | ✅ |  | 2025-10-29 |
<!-- APPS_TABLE_END -->

## ⚙️ Usage

* **Ansible:** `ansible-playbook playbook.yaml`
* **Docker Compose:** `docker-compose up -d`
* **Image builds:** Run from the `image/` directory with `docker build -t <name> .`

## 🧠 Notes

* The table above is automatically generated.
* Each app is self-contained and can be deployed independently.
* Common automation tasks are centralized in `apps/common/`.
