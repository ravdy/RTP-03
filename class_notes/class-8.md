# Prometheus setup
### pre-requisites
1. Kubernetes cluster
2. helm

## Setup Promethesu 
1. First we need to install matics server on Kubernetes
   ```sh
   kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
   ```
2. Verify the Kubernetes metric server installation 
   ```sh 
   kubectl get deployment metrics-server -n kube-system 
   or 
   kubectl get pods -n kube-system
   ```
3. Add Prometheus helm chart repository
   ```sh
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 
   ```
4. Update the helm chart repository
   ```sh
   helm repo update
   helm repo list
   ```

5. Install the prometheus
   ```sh
  helm install prometheus prometheus-community/kube-prometheus-stack
  # helm install prometheus prometheus-community/prometheus --namespace monitoring
    ```

6. Above helm create all services as ClusterIP, To access Grafana and prometheus out side of cluster, we should change service type load balancer
   ```sh 
   kubectl edit svc prometheus-kube-prometheus-prometheus
   kubectl edit svc prometheus-grafana
   ```

7. To login to Grafana account use below user name and password 
   ```sh
   username: admin
   password: prom-operator
   ```
8. Same you can find here
   ```sh 
   get secret --namespace default
   kubectl get secret --namespace default prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo 
   ```

