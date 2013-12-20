require! ['./database', fs, path, './config', imagemagick]
require! uuid: 'node-uuid'

save-avatar = !(avatar, option, callback)->
  pid = uuid.v1!
  <-! fs.mkdir config.avatar-path + "u/#{pid}"
  imagemagick.crop {
    src-path: avatar.path
    dst-path: path.normalize(config.avatar-path + "u/#{pid}/origin.jpg")
    width: option.width
    height: option.height
    # x: parseInt option.x
    # y: parseInt option.y
  }, !(err)->
    callback pid

update-user-avatar = !(uid, pid, callback)->
  query-obj = _id: uid
  update-obj = {$set: 'avatars.-1': "/avatars/u/50/#{pid}"}
  database.find-and-modify 'users', query-obj, update-obj, callback

module.exports = !(req, res)->
  if req.session.uid then
    if req.files and req.files.avatar then
      (pid) <-! save-avatar req.files.avatar, {width: 200, height: 200}
      (updated-user) <-! update-user-avatar req.session.uid, pid
      res.redirect '/'
    else res.redirect '/'
  else
    res.redirect '/'
