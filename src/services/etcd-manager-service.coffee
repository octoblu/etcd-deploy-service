_    = require 'lodash'
url  = require 'url'
Etcd = require 'node-etcd'

class EctdManager
  constructor: ({ @etcdUri, @etcdClient }) ->
    throw new Error('Missing etcdUri') unless @etcdUri?

  getEtcd: =>
    return @etcdClient ? new Etcd @_getPeers()

  _getPeers: (callback=->) =>
    return unless @etcdUri?
    peers = @etcdUri.split ','
    return _.map peers, (peer) =>
      parsedUrl = url.parse peer
      parsedUrl.host

module.exports = EctdManager
