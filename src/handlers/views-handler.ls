require! ['./database', path, fs, './config', imagemagick]

ALLOW_AVATAR_SIZE = ["30", "50", "180"]

get-user-info-with-uid = !(uid, callback)->
  (users) <-! database.query-collection 'users', {_id: uid}
  if users.length is 0 then
    callback new Error '非法的用户id，对应用户不存在'
  else
    callback users[0]

create-new-image-with-id-and-size = !(avatar-id, avatar-size, callback)->
  original-image-path = config.avatar-path + "u/#{avatar-id}/origin.jpg"
  (exists) <-! fs.exists original-image-path
  if exists is no then callback new Error '找不到源图片'
  else
    options =
      src-path: path.normalize original-image-path
      dst-path: path.normalize config.avatar-path + "u/#{avatar-id}/#{avatar-size}.jpg"
      width: avatar-size
      height: avatar-size
    (err, stdout, stderr) <-! imagemagick.resize options
    if err then callback err
    else callback null

module.exports =
  show-welcome-page: !(req, res)->
    if req.session.uid then
      (user) <-! get-user-info-with-uid req.session.uid
      if user instanceof Error then
        res.render 'index', {title: 'Home', error-message: user.message}
      else res.render 'index', {title: 'Home', user: user}
    else
      res.render 'index', {title: 'Home'}

  show-login-page: !(req, res)->
    res.redirect '/'

  show-register-page: !(req, res)->
    res.redirect '/'

  show-system-avatar: !(req, res)->
    system-avatar-id = req.params.id
    avatar-size = req.params.size
    if avatar-size not in ALLOW_AVATAR_SIZE then
      res.status 404 .send "Not Found"
    else
      (exists) <-! fs.exists config.avatar-path + "s/#{system-avatar-id}"
      system-avatar-id := 0 if exists is no
      console.log config.avatar-path + "s/#{system-avatar-id}/#{avatar-size}.jpg"
      res.sendfile config.avatar-path + "s/#{system-avatar-id}/#{avatar-size}.jpg"

  show-user-avatar: !(req, res)->
    avatar-size = req.params.size
    avatar-id = req.params.id

    default-system-avatar-path = config.avatar-path + "s/0/#{avatar-size}.jpg"

    if avatar-size not in ALLOW_AVATAR_SIZE then
      res.status 404 .send 'Not Found'
    else
      (exists) <-! fs.exists config.avatar-path + "u/#{avatar-id}"
      if exists is no then
        res.sendfile default-system-avatar-path
      else
        (exists) <-! fs.exists config.avatar-path + "u/#{avatar-id}/#{avatar-size}.jpg"
        if exists is yes then
          res.sendfile config.avatar-path + "u/#{avatar-id}/#{avatar-size}.jpg"
        else
          (image) <-! create-new-image-with-id-and-size avatar-id, avatar-size
          if image instanceof Error then
            res.status 404 .send "Not Found"
          else res.sendfile config.avatar-path + "u/#{avatar-id}/#{avatar-size}.jpg"
