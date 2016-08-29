morgan             = require 'morgan'
express            = require 'express'
bodyParser         = require 'body-parser'
compression        = require 'compression'
OctobluRaven       = require 'octoblu-raven'
enableDestroy      = require 'server-destroy'
sendError          = require 'express-send-error'
expressVersion     = require 'express-package-version'
meshbluHealthcheck = require 'express-meshblu-healthcheck'

Router             = require './router'
authorize          = require './middlewares/authorize'
EtcdManager        = require './services/etcd-manager-service'
EtcdDeployService  = require './services/etcd-deploy-service'
debug              = require('debug')('etcd-deploy-service:server')

class Server
  constructor: (options) ->
    { @logFn, @disableLogging, @port, @octobluRaven } = options
    { @deployStateUri, @deployStateKey, @deployClientKey, @etcdUri } = options
    { @requiredClusters, @etcdClient } = options
    throw new Error 'Missing deployStateUri'  unless @deployStateUri?
    throw new Error 'Missing deployStateKey'  unless @deployStateKey?
    throw new Error 'Missing deployClientKey' unless @deployClientKey?
    throw new Error 'Missing etcdUri'         unless @etcdUri?
    @octobluRaven ?= new OctobluRaven()

  address: =>
    @server.address()

  skip: (request, response) =>
    return true if @disableLogging
    return response.statusCode < 400

  run: (callback) =>
    app = express()

    app.use expressVersion { format: '{"version": "%s"}' }
    app.use meshbluHealthcheck()

    ravenExpress = @octobluRaven.express()
    app.use ravenExpress.handleErrors()
    app.use sendError({ @logFn })
    app.use bodyParser.urlencoded { limit: '1mb', extended : true }
    app.use bodyParser.json { limit : '1mb' }

    app.use authorize.auth({ token: @deployClientKey })

    etcdManager = new EtcdManager { @etcdUri, @etcdClient }

    etcdDeployService = new EtcdDeployService {
      @requiredClusters,
      @deployStateUri,
      @deployStateKey,
      @deployClientKey,
      etcdManager,
    }
    router = new Router { etcdDeployService }

    router.route app

    @server = app.listen @port, callback
    enableDestroy @server

  stop: (callback) =>
    @server.close callback

  destroy: =>
    @server.destroy()

module.exports = Server
