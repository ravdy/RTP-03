# Prometheus setup
### pre-requisites
1. Kubernetes cluster
2. helm

## Setup Prometheus

1. Create a dedicated namespace for prometheus 
   ```sh
   kubectl create namespace monitoring
   ```

2. Add Prometheus helm chart repository
   ```sh
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 
   ```

3. Update the helm chart repository
   ```sh
   helm repo update
   helm repo list
   ```

4. Install the prometheus

   ```sh
    helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring
   ```

5. Above helm create all services as ClusterIP. To access Prometheus out side of the cluster, we should change the service type load balancer
   ```sh 
   kubectl edit svc prometheus-kube-prometheus-prometheus -n monitoring
   
   ```
6. Loginto Prometheus dashboard to monitor application
   https://<ELB>:9090

7. Check for node_load15 executor to check cluster monitoring 

8. We check similar graphs in the Grafana dashboard itself. for that, we should change the service type of Grafana to LoadBalancer
   ```sh 
   kubectl edit svc prometheus-grafana
   ```

9.  To login to Grafana account, use the below username and password 
    ```sh
    username: admin
    password: prom-operator
    ```
10. Here we should check for "Node Exporter/USE method/Node" and "Node Exporter/USE method/Cluter"
    USE - Utilization, Saturation, Errors
   
11. Even we can check the behavior of each pod, node, and cluster 
   

## Integrate Prometheus with Slack
1. Create an slack account
2. Create a slack channel called "demo-alerts"
3. Install app called "incomming webooks". once installed it give a URL. Use the URL 
4. Copy below test along with URL 
   ```sh 
   curl -X POST --data-urlencode "payload={\"channel\": \"#demo-alerts\", \"username\": \"webhookbot\", \"text\": \"This is posted to #demo-alerts and comes from a bot named webhookbot.\", \"icon_emoji\": \":ghost:\"}" <Webhook_URL> 
   
   Example:    curl -X POST --data-urlencode "payload={\"channel\": \"#demo-alerts\", \"username\": \"webhookbot\", \"text\": \"This is posted to #demo-alerts and comes from a bot named webhookbot.\", \"icon_emoji\": \":ghost:\"}" https://hooks.slack.com/services/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

   ```
5. Now find out secret called "alertmanager-monitoring-kube-prometheus-alertmanager" and delete it 
   ```sh 
   kubectl get secret -n monitoring
   kubectl delete secret -n monitoring  alertmanager-my-kube-prometheus-stack-alertmanager
   ```

6. Now create a configuration file with name 'alertmanager.yaml' and copy content [from here](https://github.com/ravdy/RTP-03/blob/main/slack/alertmanager.yaml)

   `Note: make usre you have updated slack_web_url with the whebook url of slack`


7. Create a secret with an updated alertmanager.yaml file
   ```sh 
   kubectl create secret generic --from-file=alertmanager.yaml alertmanager-my-kube-prometheus-stack-alertmanager -n monitoring
   ```
   
8.  Look for the password of grafana  
    ```sh 
    get secret --namespace default
    kubectl get secret --namespace default prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo 
    ```
