require! ['./database']

get-user-with-email-and-password = !(request-data, callback)->
  (users) <-! database.query-collection 'users', {emails: request-data.email}
  if users.length is 0 then
    callback new Error '用户未被注册！'
  else
    if users[0].password isnt request-data.password then
      callback new Error '密码错误！'
    else callback users[0]

module.exports = !(req, res)->
  (user) <-! get-user-with-email-and-password req.body
  if user instanceof Error then
    res.render 'index', {title: 'Home', error-message: user.message}
  else
    req.session.uid = user._id
    res.render 'index', {title: 'Home', user: user, success-message: '登录成功！'}

