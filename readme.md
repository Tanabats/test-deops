
# Deploy Infra and Application on GKE

  

# 1. Deploy infra on GCP with Terraform



cd Terraform
1.1 VPC run terraform apply on VPC folder
**For** create network VPC and Firewall rules
1.2 VPC run terraform apply on Cluster1 folder
**For** create GKE Cluster1
1.3 VPC run terraform apply on Cluster2 folder
**For** create GKE Cluster2
1.4 VPC run terraform apply on VM folder
**For** create VM with preinstall Docker,Jenkins Server, Grafana

  
# 2. Install Mongodb replica set, Prometheus and ArogoCD

### Install gcloud command https://cloud.google.com/sdk/docs/install

Run command `gcloud container clusters get-credentials <clustername> --region asia-southeast1 --project <projectid>` for get GKE Credential
  
`kubectl create namespace mongodb`
`kubectl create namespace monitor`

### create Helm chart on Cluster2
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade -i -f helm/mongodb-values.yaml my-release bitnami/mongodb -n mongodb
helm upgrade -i -f helm/prometheus-values.yaml prometheus prometheus-community/prometheus -n monitor
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/mongodb
```


### create Prometheus Internal Loadbalance
`kubectl apply -f helm/prometheus-internal-ingress.yml -n monitor`

  
run `kubectl get pod -A` to check all resources deploy success or not

  

  

## Create GitOps CD process

  
```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -n argocd -f GitOps/application.yml
```


# 3.Deploy Application with Jenkins CI and Create DashBoard


Go to VM server and get Jenkins password

run `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`

Open browser with PubicIP VMserver with port 8080

Login with root and Jenkins password
Install recommend plugin and Docker plugin
Setting dockerhub credential and github credential


### Create JOB Pipeline Build
With pipeline from scritp https://github.com/Tanabats/test-deops.git
Scritp path Jenkinsfile
This job for create docker from dockerfile in project repo and push to docker hub

### Create JOB Pipeline updatemanifest
With pipeline from scritp https://github.com/Tanabats/test-deops.git
Scritp path Deploy/Jenkinsfile
This job for update docker image tag in deployment manifest (Deploy/deployment.yaml)


### Setting Grafana Dashboard with Prometheus mertrics
Open browser with PubicIP VMserver with port 3000
Login Grafana with user admin pass admin
Go to setting add Data source prometheus with prometheus internal url (kubectl get ingress -n monitor)
Go to Dasboard and import dasboard id 315 (from grafana community)
```