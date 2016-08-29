class EtcdDeployService
  constructor: ({ @requiredClusters, @deployStateUri, @deployStateKey, @deployClientKey, @etcdManager }) ->
    throw new Error 'Missing deployStateUri' unless @deployStateUri?
    throw new Error 'Missing deployStateKey' unless @deployStateKey?
    throw new Error 'Missing deployClientKey' unless @deployClientKey?
    throw new Error 'Missing etcdManager' unless @etcdManager?

  deployCreated: ({ something }, callback) =>
    callback()

  deployUpdated: ({ something }, callback) =>
    callback()

  _createError: (code, message) =>
    error = new Error message
    error.code = code if code?
    return error

module.exports = EtcdDeployService
