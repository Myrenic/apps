# 🧩 Apps Repository

This repository contains modular applications managed via **Ansible**, **Docker Compose**, and **custom Docker images**.
Each app resides in its own directory under `apps/`, with subfolders for automation, deployment, and build files.



## 📁 Repository Structure

<!-- APPS_TREE_START -->
```
apps/
├── common/         
├── mtu_switchtool/ 
├── netbox/         
├── pg_backup/      
├── radarr/         
├── sonarr/         
├── traefik/        
├── traefikator/    
├── zabbix-proxy/   
├── zabbix-server/  
└── zabbix-web/     
```
<!-- APPS_TREE_END -->

## 📦 App Overview

<!-- APPS_TABLE_START -->
| App | Ansible | Compose | Image | Last Commit |
| --- | --- | --- | --- | --- |
| common | ✅ |  |  | 2025-12-03 |
| mtu_switchtool | ✅ | ✅ |  | 2025-12-03 |
| netbox |  | ✅ |  | 2025-12-03 |
| pg_backup | ✅ | ✅ |  | 2025-12-03 |
| radarr |  |  | ✅ | 2025-12-03 |
| sonarr |  |  | ✅ | 2025-12-03 |
| traefik | ✅ | ✅ |  | 2025-12-03 |
| traefikator |  |  | ✅ | 2025-12-03 |
| zabbix-proxy | ✅ | ✅ |  | 2025-12-03 |
| zabbix-server | ✅ | ✅ |  | 2025-12-03 |
| zabbix-web | ✅ | ✅ |  | 2025-12-03 |
<!-- APPS_TABLE_END -->

## ⚙️ Usage

* **Ansible:** `ansible-playbook playbook.yaml`
* **Docker Compose:** `docker-compose up -d`
* **Image builds:** Run from the `image/` directory with `docker build -t <name> .`

## 🧠 Notes

* The table above is automatically generated.
* Each app is self-contained and can be deployed independently.
* Common automation tasks are centralized in `apps/common/`.

<<<<<<< HEAD

=======
>>>>>>> 731936e (chore: update portainer_deploy.yaml)



