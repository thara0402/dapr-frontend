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

## Create Azure Container Apps
```shell-session
$ az containerapp create -n dapr-frontend -g <ResourceGroup Name> -e <Environment Name> -i thara0402/dapr-frontend:0.1.0 --ingress external --target-port 80 --revisions-mode multiple --scale-rules ./deploy/httpscaler.json --max-replicas 10 --min-replicas 1
```

## UPdate Azure Container Apps
```shell-session
$ az containerapp update -n dapr-frontend -g <ResourceGroup Name> -i thara0402/dapr-frontend:0.2.0
```

## Blue / Green Deploy for Azure Container Apps
```shell-session
# Get Current Revison Name
$ az containerapp revision list -g gooner1107 -n dapr-frontend --query "[].{Revision:name,Replicas:replicas,Active:active,Created:createdTime,FQDN:fqdn}" -o table

# Deploy New Revision
$ az containerapp update -n dapr-frontend -g <ResourceGroup Name> -i thara0402/dapr-frontend:0.2.0 --traffic-weight dapr-frontend--h2qwxun=100,latest=0

# Swap
$ az containerapp update -n dapr-frontend -g <ResourceGroup Name> --traffic-weight dapr-frontend--h2qwxun=0,latest=100

# Deactivate Old Revision
$ az containerapp revision deactivate --app dapr-frontend -g <ResourceGroup Name> --name dapr-frontend--h2qwxun
```
