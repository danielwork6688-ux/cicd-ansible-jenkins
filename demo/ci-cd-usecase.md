# Real CI/CD Demo: Spring Petclinic

This demo uses the infrastructure provisioned by this Ansible project.

## What The Demo Shows

Jenkins runs a pipeline that:

1. Checks out Spring Petclinic from GitHub.
2. Runs Maven tests.
3. Sends static analysis results to SonarQube.
4. Packages the application.
5. Builds a Docker image.
6. Deploys the app as a Docker container.

## Prerequisites

Provision the platform:

```bash
ansible-playbook infra.yml
```

Verify the build host:

```bash
systemctl status docker
systemctl status jenkins
curl -I http://127.0.0.1:8080
```

Verify the shared-services host:

```bash
ssh -i /home/azureuser/.ssh/ansible_target_key azureuser@<TARGET_IP>
sudo systemctl status postgresql
sudo systemctl status sonarqube
sudo systemctl status nexus
curl -I http://127.0.0.1:9000
curl -I http://127.0.0.1:8081
```

## Configure SonarQube

Open:

```text
http://<TARGET_IP>:9000
```

Create a SonarQube token for Jenkins.

## Configure Jenkins

Open:

```text
http://<BUILD_HOST_IP>:8080
```

Unlock Jenkins:

```bash
sudo cat /home/azureuser/.jenkins/secrets/initialAdminPassword
```

Install the required Jenkins plugins:

- Pipeline
- Git
- Credentials

Add the SonarQube token to Jenkins credentials:

```text
Kind: Secret text
ID: sonar-token
Secret: <SonarQube token>
```

## Create The Pipeline Job

Create a new Jenkins job:

```text
New Item -> Pipeline -> petclinic-ci-cd
```

Use the contents of:

```text
demo/Jenkinsfile.petclinic
```

Before running it, replace these placeholders:

- `TARGET_HOST_IP` with the shared-services host IP.
- `BUILD_HOST_IP` with the build host IP.

## Run The Demo

Click:

```text
Build Now
```

Expected result:

- Jenkins checks out Spring Petclinic.
- Tests pass.
- SonarQube receives a `spring-petclinic` project analysis.
- Jenkins builds a Docker image.
- Jenkins deploys the app container.

Open the deployed app:

```text
http://<BUILD_HOST_IP>:8082
```

Open the SonarQube dashboard:

```text
http://<TARGET_IP>:9000/dashboard?id=spring-petclinic
```

## Useful Checks

On the build host:

```bash
docker images | grep spring-petclinic
docker ps --filter name=spring-petclinic-demo
curl -I http://127.0.0.1:8082
```

Jenkins logs:

```bash
journalctl -u jenkins -n 100
```

SonarQube logs on the shared-services host:

```bash
sudo journalctl -u sonarqube -n 100
```

