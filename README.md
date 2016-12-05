# Workshop: Kubernetes for Developers

Workshop at [Kubernetes Philly](https://www.meetup.com/Kubernetes-Philly/events/234829676/)

## Presenter
[Ross Kukulinski](https://twitter.com/rosskukulinski)


## Workshop Description

Kubernetes accelerates technical and business innovation through rapid development and deployment of applications. Learn how to deploy, scale, and manage your applications in a containerized environments using Kubernetes.  

In this 60-minute workshop, Ross Kukulinski will review fundamental Kubernetes concepts and architecture and then will show how to containerize and deploy a multi-tier web application to Kubernetes.  

Topics that will be covered include:

• Working with the Kubernetes CLI (kubectl)

• Pods, Deployments, & Services

• Manual & Automated Application Scaling

• Troubleshooting and debugging

• Persistent storage


## Workshop Slides

[Workshop Slides - TBD]()  
[Workshop Video - TBD]()  
[Workshop Screencast - TBD]()

## Background Reading / Videos

https://vimeo.com/172626818
http://kubernetes.io/docs/hellonode/
http://www.slideshare.net/kuxman/nodejs-and-containers-go-together-like-peanut-butter-and-jelly

## Outline

* Welcome & Introductions
* Installing minikube & kubectl
* Kubernetes Overview
* Cloudy Time Machine (CTM) Overview
* Deploy CTM to minikube / Kubernetes

## Deploying Cloudy Time Machine to Kubernetes

### Installing minikube

Follow instructions at https://github.com/kubernetes/minikube/releases

For OSX:

```
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.13.0/minikube-darwin-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
```

### minikube hello world

```minikube start```

```kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080```

```kubectl expose deployment hello-minikube --type=NodePort```

```kubectl get pod```

```curl $(minikube service hello-minikube --url)```

```minikube stop```

### Working with minikube

```minikube start```

```minikube stop```

```minikube service <servicename>```

```minikube dashboard```

```minikube ip```

```minikube docker-env```

```minikube logs```


### Working with kubectl

```kubectl config current-context```

```kubectl config use-context minikube```

```kubectl get nodes```

```kubectl describe node <nodeid>```

```kubectl get pods```

```kubectl get namespaces```

```kubectl -n kube-system get pods```

```kubectl -n kube-system get services```

```kubectl -n kube-system get svc```

```kubectl -n kube-system describe svc kubernetes-dashboard```

```kubectl run -i -t busybox --image=busybox --restart=Never```


### Deploy CTM frontend manually

The CTM [frontend](https://github.com/cloudytimemachine/frontend) application can run standalone, so let's start with that.

```kubectl run frontend --image=quay.io/cloudytimemachine/frontend:25f9df2e9c991745a02ef5fdd249a542c53d6d8a --image-pull-policy=IfNotPresent```

```kubectl get pods```

```kubectl get events --watch```

```kubectl describe pod <pod id>```

```kubectl port-forward <pod id> 3000:80```

```curl localhost:3000```

```kubectl exec -ti <frontend pod> /bin/sh```

```vi index.html```

```curl localhost:3000```

```kubectl expose deployment frontend --port=80 --target-port=3000 --name=frontend```

```kubectl describe svc frontend```

```kubectl scale deployment/frontend --replicas=2```

```kubectl describe svc frontend```

```kubectl edit pod <frontend pod>``` # Edit label to remove from the pool

```kubectl get pods```

```kubectl edit svc/frontend``` # Change to type: NodePort

```minikube service frontend```

```kubectl delete deployment/frontend svc/frontend```

```kubectl delete pod <frontend pod>```


###  Deploy Frontend using declarative syntax

```atom deploy/frontend.yml```

```kubectl create -f deploy/frontend.yml```

```kubectl get pods```

```kubectl get svc```


###  Remind audience about architecture

![Insert architecture image here]()


### Deploy API service using declarative syntax

[API Service](https://github.com/cloudytimemachine/api) depends on Redis and RethinkDB, so lets create them first.

```atom deploy/redis.yml```

```kubectl create -f deploy/redis.yml```

```kubectl get pods```

```kubectl port-forward <redis pod> 6379:6379```

```redis-cli ```

Kubectl can also create from URL (Similar to  `curl | bash`)

```kubectl create -f https://raw.githubusercontent.com/rosskukulinski/kubernetes-rethinkdb-cluster/master/rethinkdb-quickstart.yml```

```kubectl get pods --watch```

```minikube service rethinkdb-admin```

```atom deploy/api.yml```

```kubectl create -f deploy/api.yml```

```kubectl get pods```

```kubectl get svc```

```kubectl logs <api pod> --tail=10 -f```

```kubectl logs <api pod> --tail=10 -f | bunyan```


### Deploy Gateway service to expose frontend & api

```atom deploy/gateway.yml```

```kubectl create -f deploy/gateway.yml```

```kubectl get configmap```

```kubectl get pods```

```kubectl describe svc gateway```

```minikube service gateway```

Navigate to /api/snapshots --> See empty array

Request snapshot for xkcd.com, gets queued in Redis

### Deploy worker-screenshot service

```atom deploy/worker-screenshot.yml```

```kubectl create -f deploy/worker-screenshot.yml```

```kubetctl get pods --watch```

```kubectl logs <worker pod> -f | bunyan```

Request additional snapshots, see the queue size increase

```kubectl scale deployment/worker-screenshot --replicas=3```

```kubectl get pods --watch```

### Tear everything down

```kubectl delete namespace default --cascade=true```

### Bring it back up

```
make
kubectl create -f deploy/all-in-one.yml
```

### Back to slides to wrap up
# kubernetes-101-for-devs
