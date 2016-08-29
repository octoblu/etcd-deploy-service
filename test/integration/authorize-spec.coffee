request       = require 'request'
shmock        = require 'shmock'
enableDestroy = require 'server-destroy'
Server        = require '../../src/server'

describe 'Authorize', ->
  beforeEach (done) ->
    @logFn = sinon.spy()

    @deployStateService = shmock "#{0xdead}"
    enableDestroy @deployStateService

    serverOptions =
      port            : undefined,
      disableLogging  : true
      logFn           : @logFn
      deployStateKey  : 'deploy-state-key'
      deployStateUri  : "http               : //localhost : #{0xdead}"
      deployClientKey : 'deploy-client-key'
      etcdUri         : 'something'

    @server = new Server serverOptions

    @server.run =>
      @serverPort = @server.address().port
      done()

  afterEach ->
    @server.destroy()
    @deployStateService.destroy()

  describe 'on GET /authorize', ->
    describe 'when authorized', ->
      beforeEach (done) ->
        options =
          uri: '/authorize'
          baseUrl: "http://localhost:#{@serverPort}"
          headers:
            Authorization: 'token deploy-client-key'
          json: true

        request.get options, (error, @response, @body) =>
          done error

      it 'should return a 204', ->
        expect(@response.statusCode).to.equal 204

    describe 'when missing the authorization key', ->
      beforeEach (done) ->
        options =
          uri: '/authorize'
          baseUrl: "http://localhost:#{@serverPort}"
          json: true

        request.get options, (error, @response, @body) =>
          done error

      it 'should return a 401', ->
        expect(@response.statusCode).to.equal 401

    describe 'when the authorization type is wrong', ->
      beforeEach (done) ->
        options =
          uri: '/authorize'
          baseUrl: "http://localhost:#{@serverPort}"
          headers:
            Authorization: 'wrong deploy-client-key'
          json: true

        request.get options, (error, @response, @body) =>
          done error

      it 'should return a 401', ->
        expect(@response.statusCode).to.equal 401

    describe 'when the authorization key is wrong', ->
      beforeEach (done) ->
        options =
          uri: '/authorize'
          baseUrl: "http://localhost:#{@serverPort}"
          headers:
            Authorization: 'token not-the-deploy-client-key'
          json: true

        request.get options, (error, @response, @body) =>
          done error

      it 'should return a 403', ->
        expect(@response.statusCode).to.equal 403

