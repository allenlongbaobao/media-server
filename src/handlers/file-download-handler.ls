require! ['fs', './config']

get-target-path = !(audio-path, callback)->
  #reg = Reg-exp '/.*'
  #callback '/home/zwx/allen/my-media-server/at-plus-media-server/statics/audios' + reg.exec audio-path
  callback config.audio-path + audio-path

module.exports = !(req, res, next)->
  (target-path) <-! get-target-path req.query.audio-path
  (err) <-! res.download target-path
  console.log err if err



