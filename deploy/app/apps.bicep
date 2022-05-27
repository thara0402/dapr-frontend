param containerAppName string
param location string = resourceGroup().location
param environmentId string
param containerImage string
param revisionSuffix string
param oldRevisionSuffix string
param isExternalIngress bool

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
        traffic: ((contains(revisionSuffix, oldRevisionSuffix)) ? [
          {
            weight: 100
            latestRevision: true
          }
        ] : [
          {
            weight: 0
            latestRevision: true
          }
          {
            weight: 100
            revisionName: '${containerAppName}--${oldRevisionSuffix}'
          }
        ])
      }
      dapr:{
        enabled:false
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
