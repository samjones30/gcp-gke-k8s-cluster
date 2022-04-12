# Istio Sample Booksite

Deploying a sample site using - https://istio.io/latest/docs/setup/getting-started/

## Deployment

1. Apply the sample from the Istio directory above: `kubectl apply -f ./istio*/samples/bookinfo/platform/kube/bookinfo.yaml`
2. Deploy the sleep application to test the application: `kubectl apply -f ./istio*/samples/sleep/sleep.yaml`
3. Confirm the test application is running: `kubectl exec $(kubectl get pod -l app=sleep -o jsonpath='{.items[0].metadata.name}') -c sleep -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"`
4. Patch the productpage service to change it from ClusterIP to LoadBalancer `kubectl patch svc productpage -p '{"spec": {"type": "LoadBalancer"}}'`
5. Deploy the ingress resource: `kubectl apply -f istio-booksite-ingress.yaml`
6. Deploy the gateway resources: `kubectl apply -f ./istio-*/samples/bookinfo/networking/bookinfo-gateway.yaml`
7. Check access to the service using the /productpage URL.

## Testing

The main use case for this sample application is playing around with Istio. To generate some fake traffic, use the following:

`for i in $(seq 1 100); do curl -s -o /dev/null "http://$GATEWAY_URL/productpage"; done`

Where GATEWAY_URL is the load balancer IP and port for our new book site.
