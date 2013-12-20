module.exports = !(req, res)->
  req.session.uid = null
  res.redirect '/'

