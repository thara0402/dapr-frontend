# Dapr Front-End Web Application

## Build and Push Docker Images
```shell-session
$ docker build -t thara0402/dapr-frontend:0.1.0 ./
$ docker run --rm -it -p 8000:80 --name frontend thara0402/dapr-frontend:0.1.0
$ docker push thara0402/dapr-frontend:0.1.0
```

## Create Azure Container Apps environment
```shell-session
$ az group create -n <ResourceGroup Name> -l canadacentral
$ az deployment group create -f ./deploy/main.bicep -g <ResourceGroup Name>
```

## Blue-Green Deployments
### Create Azure Container Apps
```shell-session
$ az containerapp create -n dapr-frontend -g <ResourceGroup Name> -e <Environment Name> -i thara0402/dapr-frontend:0.1.0 --ingress external --target-port 80 --revisions-mode multiple --scale-rules ./deploy/httpscaler.json --max-replicas 10 --min-replicas 1
```

### Update Azure Container Apps
```shell-session
$ az containerapp update -n dapr-frontend -g <ResourceGroup Name> -i thara0402/dapr-frontend:0.2.0
```

### Blue-Green Deployments
```shell-session
# Get Current Revison Name
$ az containerapp revision list -g <ResourceGroup Name> -n dapr-frontend --query "[].{Revision:name,Replicas:replicas,Active:active,Created:createdTime,FQDN:fqdn}" -o table

# Deploy New Revision
$ az containerapp update -n dapr-frontend -g <ResourceGroup Name> -i thara0402/dapr-frontend:0.2.0 --traffic-weight dapr-frontend--h2qwxun=100,latest=0

# Swap
$ az containerapp update -n dapr-frontend -g <ResourceGroup Name> --traffic-weight dapr-frontend--h2qwxun=0,latest=100

# Deactivate Old Revision
$ az containerapp revision deactivate --app dapr-frontend -g <ResourceGroup Name> --name dapr-frontend--h2qwxun
```

## Dapr - Service to Service calls
### Create Azure Container Apps for frontend
```shell-session
$ az containerapp create -n dapr-frontend -g <ResourceGroup Name> \
     -e <Environment Name> -i thara0402/dapr-frontend:0.9.0 \
     --ingress external --target-port 80 \
     --revisions-mode single --scale-rules ./deploy/httpscaler.json \
     --max-replicas 10 --min-replicas 1 \
     --enable-dapr --dapr-app-id dapr-frontend --dapr-app-port 80
```
### Create Azure Container Apps for backend
[Dapr Back-End Web Api](https://github.com/thara0402/dapr-backend)