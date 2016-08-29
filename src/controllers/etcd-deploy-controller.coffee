class EtcdDeployController
  constructor: ({@etcdDeployService}) ->
    throw new Error 'Missing etcdDeployService' unless @etcdDeployService?

  deployCreated: (request, response) =>
    { repo, owner, build } = request.body
    @etcdDeployService.deployCreated { repo, owner, build }, (error) =>
      return response.sendError(error) if error?
      response.sendStatus(201)

  deployUpdated: (request, response) =>
    { repo, owner, build } = request.body
    @etcdDeployService.deployUpdated { repo, owner, build }, (error) =>
      return response.sendError(error) if error?
      response.sendStatus(204)

module.exports = EtcdDeployController
