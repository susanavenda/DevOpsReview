#Stop and delete Minikube
minikube stop
minikube delete --all --purge

# Remove all Kubernetes resources
kubectl delete --all deployments
kubectl delete --all services
kubectl delete --all pods
docker rm -f $(docker ps -a -q)
docker rmi -f $(docker images -q)
rm -rf target/