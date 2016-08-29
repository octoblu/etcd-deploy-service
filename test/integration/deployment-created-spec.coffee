request       = require 'request'
shmock        = require 'shmock'
enableDestroy = require 'server-destroy'
Server        = require '../../src/server'

describe 'Deployment Create', ->
  beforeEach (done) ->
    @logFn = sinon.spy()

    @deployStateService = shmock "#{0xdead}"
    enableDestroy @deployStateService

    serverOptions =
      port            : undefined,
      disableLogging  : true
      logFn           : @logFn
      deployStateKey  : 'deploy-state-key'
      deployStateUri  : "http://localhost:#{0xdead}"
      deployClientKey : 'deploy-client-key'
      etcdUri         : 'something'

    @server = new Server serverOptions

    @server.run =>
      @serverPort = @server.address().port
      done()

  afterEach ->
    @server.destroy()
    @deployStateService.destroy()

  describe 'on POST /deployments', ->
    describe 'when called with a non-passing build', ->
      beforeEach (done) ->
        options =
          uri: '/deployments'
          baseUrl: "http://localhost:#{@serverPort}"
          headers:
            Authorization: 'token deploy-client-key'
          json:
            tag   : 'v1.0.0'
            repo  : 'the-service'
            owner : 'the-owner'
            build : {
              passing: false
            }

        request.post options, (error, @response, @body) =>
          done error

      it 'should return a 201', ->
        expect(@response.statusCode).to.equal 201

