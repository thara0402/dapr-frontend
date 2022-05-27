param environmentName string = 'env-${resourceGroup().name}'
param containerAppName string = 'dapr-frontend'
param location string = resourceGroup().location
param containerImage string = 'thara0402/dapr-frontend:0.1.0'
param revisionSuffix string = 'v1'
param oldRevisionSuffix string = 'v1'
param isExternalIngress bool = true
param revisionMode string = 'multiple'

resource environment 'Microsoft.App/managedEnvironments@2022-03-01' existing = {
  name: environmentName
}

module apps 'apps.bicep' = {
  name: 'container-apps'
  params: {
    containerAppName: containerAppName
    location: location
    environmentId: environment.id
    containerImage: containerImage
    revisionSuffix: revisionSuffix
    oldRevisionSuffix: oldRevisionSuffix
    revisionMode: revisionMode
    isExternalIngress: isExternalIngress
  }
}
