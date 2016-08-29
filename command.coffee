_            = require 'lodash'
OctobluRaven = require 'octoblu-raven'
Server       = require './src/server'

class Command
  constructor: ->
    @octobluRaven  = new OctobluRaven()
    @serverOptions = {
      port             : process.env.PORT || 80
      disableLogging   : process.env.DISABLE_LOGGING == "true"
      deployStateUri   : process.env.DEPLOY_STATE_URI
      deployStateKey   : process.env.DEPLOY_STATE_KEY
      deployClientKey  : process.env.DEPLOY_CLIENT_KEY
      requiredClusters : process.env.REQUIRED_CLUSTERS
      etcdUri          : process.env.ETCD_URI
      @octobluRaven,
    }

  handleErrors: =>
    @octobluRaven.patchGlobal()

  panic: (error) =>
    console.error error.stack
    process.exit 1

  run: =>
    @panic new Error('Missing environment variable: DEPLOY_STATE_URI') unless @serverOptions.deployStateUri?
    @panic new Error('Missing environment variable: DEPLOY_STATE_KEY') unless @serverOptions.deployStateKey?
    @panic new Error('Missing environment variable: DEPLOY_CLIENT_KEY') unless @serverOptions.deployClientKey?
    @panic new Error('Missing environment variable: ETCD_URI') unless @serverOptions.etcdUri?
    @panic new Error('Missing environment variable: PORT') unless @serverOptions.port?

    server = new Server @serverOptions
    server.run (error) =>
      return @panic error if error?

      {address,port} = server.address()
      console.log "EtcdDeployService listening on port: #{port}"

    process.on 'SIGTERM', =>
      console.log 'SIGTERM caught, exiting'
      process.exit 0 unless server.stop?
      server.stop =>
        process.exit 0

command = new Command()
command.handleErrors()
command.run()
