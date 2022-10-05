helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm upgrade -i -f helm/mongodb-values.yaml my-release bitnami/mongodb -n mongodb 

helm upgrade -i -f helm/prometheus-values.yaml prometheus prometheus-community/prometheus -n monitor