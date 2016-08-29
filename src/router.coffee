EtcdDeployController = require './controllers/etcd-deploy-controller'

class Router
  constructor: ({ @etcdDeployService }) ->
    throw new Error 'Missing etcdDeployService' unless @etcdDeployService?

  route: (app) =>
    etcdDeployController = new EtcdDeployController { @etcdDeployService }

    app.post '/deployments', etcdDeployController.deployCreated
    app.put  '/deployments', etcdDeployController.deployUpdated
    app.get  '/authorize', (request, response) => response.sendStatus(204)

module.exports = Router
