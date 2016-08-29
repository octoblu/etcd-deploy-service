class EtcdDeployService
  constructor: ({ @deployStateUri, @deployStateKey, @deployClientKey, @etcdUri }) ->
    throw new Error 'Missing deployStateUri' unless @deployStateUri?
    throw new Error 'Missing deployStateKey' unless @deployStateKey?
    throw new Error 'Missing deployClientKey' unless @deployClientKey?
    throw new Error 'Missing etcdUri' unless @etcdUri?

  deployStateChange: ({ something }, callback) =>
    callback()

  _createError: (code, message) =>
    error = new Error message
    error.code = code if code?
    return error

module.exports = EtcdDeployService
