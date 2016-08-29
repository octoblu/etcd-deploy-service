class EtcdDeployController
  constructor: ({@etcdDeployService}) ->
    throw new Error 'Missing etcdDeployService' unless @etcdDeployService?

  deployStateChange: (request, response) =>
    @etcdDeployService.deployStateChange { }, (error) =>
      return response.sendError(error) if error?
      response.sendStatus(200)

module.exports = EtcdDeployController
