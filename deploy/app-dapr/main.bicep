param environmentName string = 'env-${resourceGroup().name}'
param containerAppName string = 'dapr-frontend'
param location string = resourceGroup().location
param containerImage string = 'thara0402/dapr-frontend:0.9.0'
param revisionSuffix string = ''
param isExternalIngress bool = true
param revisionMode string = 'single'
param isDaprenabled bool = true
param daprAppId string = 'dapr-frontend'

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
    revisionMode: revisionMode
    isExternalIngress: isExternalIngress
    isDaprenabled: isDaprenabled
    daprAppId: daprAppId
  }
}
