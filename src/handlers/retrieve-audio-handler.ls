require! ['fs', './config']

check-audio-existed = !(file-suffix, callback)->
  (existed) <-! fs.exists config.audio-path + file-suffix
  callback existed

get-access-url = (file-suffix)->
  config.audio-path + file-suffix

module.exports = !(req, res, callback)->
  (existed) <-! check-audio-existed req.params[0]
  if existed
    access-url = get-access-url req.params[0]
    res.sendfile access-url
  else
    res.send {result: 'failed'}



