```
1. Deploy infa on GCP with Terraform
cd Terraform
1.1 VPC run terraform apply on VPC folder
for create network VPC and Firewall rules
1.2 VPC run terraform apply on Cluster1 folder
for create GKE Cluster1
1.3 VPC run terraform apply on Cluster2 folder
for create GKE Cluster2
1.4 VPC run terraform apply on VM folder
for create VM with preinstall Docker,Jenkins Server, Grafana

After all Terraform create completed

2. 
Install gcloud command https://cloud.google.com/sdk/docs/install 
Run command   gcloud container clusters get-credentials <clustername> --region asia-southeast1 --project <projectid>  for get GKE Credential
kubectl create namespace mongodb 
kubectl create namespace monitor

create Helm chart on Cluster2
install helm
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade -i -f helm/mongodb-values.yaml my-release bitnami/mongodb -n mongodb 
helm upgrade -i -f helm/prometheus-values.yaml prometheus prometheus-community/prometheus -n monitor

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/mongodb
kubectl apply -f helm/prometheus-internal-ingress.yml -n monitor

run ``kubectl get pod -A `` to check all resources deploy success or not


create GitOps CD process
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -n argocd -f GitOps/application.yml


after deploy helm chart and argocd completed
3.
Deploy application 
go to VM server go get Jenkins password  
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

Open browser with PubicIP VMserver with port 8080
Login with root and Jenkins password  
Install recommend plugin and Docker plugin
setting dockerhub credential and github credential

create JOB Pipeline Build 
with pipeline from scritp https://github.com/Tanabats/test-deops.git 
scritp path Jenkinsfile
this job for create docker from dockerfile in project repo and push to docker hub


create JOB Pipeline updatemanifest 
with pipeline from scritp https://github.com/Tanabats/test-deops.git 
scritp path Deploy/Jenkinsfile
this job for update docker image tag in deployment manifest (Deploy/deployment.yaml)


Open browser with PubicIP VMserver with port 3000
Login Grafana with user admin pass admin
go to setting add Data source prometheus with prometheus internal url (kubectl get ingress -n monitor)

go to Dasboard and import dasboard id 315 (from grafana community)


```