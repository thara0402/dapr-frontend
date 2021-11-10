param environmentName string = 'env-${resourceGroup().name}'

module environment 'environment.bicep' = {
  name: 'container-app-environment'
  params: {
    environmentName: environmentName
  }
}
