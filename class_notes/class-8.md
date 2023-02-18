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
7. View the Prometheus dashboard by forwarding the deployment ports
   ```sh
   kubectl port-forward prometheus-prometheus-kube-prometheus-prometheus-0 8000:9090
   ```

8. By default all prots are ClusterIP. We should create node port for prometheus server to access from external network 
   ```sh
   kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext 
   ```
