require! ['fs', './config', 'uuid']

get-file-suffix = (uid)->
  file-suffix = 'u/' + "#uid/" + uuid! + '.mp3'

get-target-path = !(uid, file-suffix, callback)->
  (exists) <-! fs.exists config.audio-path + 'u/' + "#{uid}"
  if not exists
    (err)<-! fs.mkdir config.audio-path +  'u/' + "#{uid}"
    console.log err if err
    callback config.audio-path + file-suffix
  else
    callback config.audio-path + file-suffix

module.exports = !(req, res, next)->
  uid = req.body.user-id or 'unlogin-user'
  tmp-path = req.files.audio.path
  file-suffix = get-file-suffix uid
  (target-path) <-! get-target-path uid, file-suffix
  (err) <-! fs.rename tmp-path, target-path
  if err then res.send {result: 'failed', messages: 'save audio failed'}
  else 
    res.send {result: 'success', audio-url: file-suffix}


