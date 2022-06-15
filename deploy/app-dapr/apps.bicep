param containerAppName string
param location string = resourceGroup().location
param environmentId string
param containerImage string
param revisionSuffix string
param isExternalIngress bool
param isDaprenabled bool
param daprAppId string

@allowed([
  'multiple'
  'single'
])
param revisionMode string = 'single'

resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: containerAppName
  location: location
  properties: {
    managedEnvironmentId: environmentId
    configuration: {
      activeRevisionsMode: revisionMode
      ingress: {
        external: isExternalIngress
        targetPort: 80
        transport: 'auto'
        allowInsecure: false
      }
      dapr: {
        enabled: isDaprenabled
        appId: daprAppId
        appPort: 80
        appProtocol: 'http'
      }
    }
    template: {
      revisionSuffix: revisionSuffix
      containers: [
        {
          image: containerImage
          name: containerAppName
          resources: {
            cpu: '0.25'
            memory: '0.5Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 10
        rules: [
          {
            name: 'http-scaling-rule'
            http: {
              metadata: {
                concurrentRequests: '10'
              }
            }
          }
        ]
      }
    }
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn
