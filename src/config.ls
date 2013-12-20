require! path
module.exports =
  port: 8003
  mongo:
    db: 'at-plus-test'
    host: 'localhost'
    port: 27017
    write-concern: -1
    collections: ['users', 'interesting-points', 'interesting-point-sessions', 'locations', 'messages', 'chats', 'circles']
  mime-type:
    css: 'text/css'
    gif: 'image/gif'
    html: 'text/html'
    ico: 'image/x-icon'
    jpeg: 'image/jpeg'
    jpg: 'image/jpeg'
    js: 'text/javascript'
    json: 'application/json'
    pdf: 'application/pdf'
    png: 'image/png'
    svg: 'image/svg+xml'
    swf: 'application/x-shockwave-flash'
    tiff: 'image/tiff'
    txt: 'text/plain'
    wav: 'audio/x-wav'
    wma: 'audio/x-ms-wma'
    wmv: 'video/x-ms-wmv'
    xml: 'text/xml'
  expires:
    file-math: /^(gif|png|jpg|js|css)$/ig
    max-age: 365 * 24 * 60 * 60
  welcome:
    file: 'index.html'
  avatar-path: path.normalize __dirname + '/../statics/avatars/'
  audio-path: path.normalize __dirname + '/../statics/audios/'
  ip: '172.16.21.226/'
