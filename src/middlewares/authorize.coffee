class Authorize
  auth: ({ @token }) =>
    throw new Error 'Missing token' unless @token?
    return @_auth

  _auth: (request, response, next) =>
    authHeader = request.get 'Authorization'
    return response.sendStatus(401) unless authHeader?
    [key, value] = authHeader.split ' '
    return response.sendStatus(401) unless key == 'token'
    return response.sendStatus(401) unless value?
    token = value.trim()
    return response.sendStatus(403) unless token == @token
    next()

module.exports = new Authorize
