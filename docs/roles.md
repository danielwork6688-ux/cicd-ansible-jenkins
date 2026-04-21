# Role Reference

This project uses Ansible roles to keep each infrastructure responsibility separate.

## Execution Flow

```text
infra.yml
  -> build_servers
       -> common
       -> jenkins_docker
  -> shared_services
       -> common
       -> nexus
       -> sonarqube
```

## common

Purpose: prepare a host with baseline tooling.

Main work:

- Optionally updates all packages when `update_all_packages: true`.
- Installs Git, curl, wget, unzip, tar, Python, pip, and Java 17.
- Sets `JAVA_HOME` in `/etc/environment`.

## jenkins_docker

Purpose: turn the build host into a Jenkins worker/control host that can run Docker builds.

Main work:

- Installs Docker repository dependencies.
- Adds the Docker CE repository.
- Installs Docker Engine, CLI, containerd, and Docker Compose plugin.
- Starts and enables Docker.
- Adds the Ansible user to the `docker` group.
- Downloads the configured Jenkins WAR file.
- Creates and enables a `systemd` service for Jenkins.

Jenkins runs directly on the host as a Java process, not inside a Docker container.

## nexus

Purpose: install Nexus Repository Manager on the shared-services host.

Main work:

- Creates a dedicated `nexus` system user.
- Creates the install and data directories.
- Downloads and extracts Nexus.
- Configures Nexus to run as the `nexus` user.
- Creates and enables a `systemd` service.

## sonarqube

Purpose: install SonarQube with PostgreSQL on the shared-services host.

Main work:

- Creates the SonarQube service user.
- Installs PostgreSQL and Python PostgreSQL bindings.
- Initializes and starts PostgreSQL.
- Configures local PostgreSQL password authentication for SonarQube.
- Creates the SonarQube database and database user.
- Downloads and extracts SonarQube.
- Writes SonarQube JDBC configuration.
- Creates and enables a `systemd` service.

## Variables

Shared variables live in `group_vars/all/main.yml`.

Sensitive variables should live in `group_vars/all/vault.yml`, which is ignored by Git. Use `group_vars/all/vault.example.yml` as the template.

