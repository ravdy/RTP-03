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
5. Create prometheus namespace
   ```sh 
   kubectl create namespace prometheus
   ```

6. Install the prometheus
   ```sh
 helm install prometheus prometheus-community/prometheus  --namespace prometheus
    ```

7. List out the prometheus 
   ```sh 
   kubectl get all - n prometheus
   ```

8. View the Prometheus dashboard by forwarding the deployment ports
   ```sh
   kubectl port-forward deployment/prometheus-server 9090:9090 -n prometheus
   ```

9. By default all prots are ClusterIP. We should create node port for prometheus server to access from external network 
   ```sh
   kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext 
   ```
