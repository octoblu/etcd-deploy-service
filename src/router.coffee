EtcdDeployController = require './controllers/etcd-deploy-controller'

class Router
  constructor: ({ @etcdDeployService }) ->
    throw new Error 'Missing etcdDeployService' unless @etcdDeployService?

  route: (app) =>
    etcdDeployController = new EtcdDeployController { @etcdDeployService }

    app.post '/deployments/changed', etcdDeployController.deployStateChange
    app.get  '/authorize', (request, response) => response.sendStatus(204)

module.exports = Router
