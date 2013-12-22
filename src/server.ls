require! ['./config', express, path, './verify-handler', './views-handler', './login-handler', './register-handler', './logout-handler',
          './avatar-upload-handler', './update-profile-handler', './file-upload-handler', './file-download-handler', './retrieve-audio-handler']

server = express!

configure-server = !->
  server.use express.logger!
  server.use express.cookie-parser!
  server.use express.session {secret: '@+ is awesome!!!'}
  server.use express.body-parser!
  server.use express.static path.normalize __dirname + '/../resource/'
  server.set 'view engine', 'jade'
  server.set 'views', path.normalize __dirname + '/../views/'

register-handlers-to-server = !->

  server.get '/', views-handler.show-welcome-page
  server.get '/login', views-handler.show-login-page
  server.get '/register', views-handler.show-register-page
  server.get '/avatars/u/:size/:id', views-handler.show-user-avatar
  server.get '/avatars/s/:size/:id', views-handler.show-system-avatar
  server.get '/file-download', file-download-handler

  server.post '*', verify-handler # 过滤器
  server.get '/audio/*', retrieve-audio-handler

  server.post '/login', login-handler
  server.post '/register', register-handler
  server.post '/logout', logout-handler
  server.post '/upload_avatar', avatar-upload-handler
  server.post '/update_profile', update-profile-handler
  server.post '/file-upload', file-upload-handler

start-server = !->
  server.listen config.port, !->
    console.info "@+ server is listening on #{config.port}"

module.exports =
  start: !->
    configure-server!
    register-handlers-to-server!
    start-server!
