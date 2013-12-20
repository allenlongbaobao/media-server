require! ['./database']

update-user-profile = !(request-data, callback)->
  query-obj = _id: request-data.uid
  update-obj = {$set: {gender: request-data.gender, username: request-data.username, 'signatures.-1': request-data.signature}}
  database.find-and-modify 'users', query-obj, update-obj, callback

module.exports = !(req, res)->
  console.log req.body
  (updated-user) <-! update-user-profile (req.body <<< {uid: req.session.uid})
  res.render 'index', {title: "Home", user: updated-user, success-message: '修改成功！'}
