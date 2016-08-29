class EtcdDeployController
  constructor: ({@etcdDeployService}) ->
    throw new Error 'Missing etcdDeployService' unless @etcdDeployService?

  deployCreated: (request, response) =>
    @etcdDeployService.deployCreated { }, (error) =>
      return response.sendError(error) if error?
      response.sendStatus(201)

  deployUpdated: (request, response) =>
    @etcdDeployService.deployUpdated { }, (error) =>
      return response.sendError(error) if error?
      response.sendStatus(204)

module.exports = EtcdDeployController
