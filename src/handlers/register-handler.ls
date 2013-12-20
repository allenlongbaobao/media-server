require! ['./database', fs, './config']
require! uuid: 'node-uuid'

get-user-schema = (request-data)->
  user-id = uuid.v1!
  {
    _id: user-id
    gender: 'U'
    username: request-data.username
    password: request-data.password
    emails: [request-data.email]
    avatars: ['/avatars/s/50/0']
    signatures: ['暂无']
    third-part-accounts: []
    circles: []
    friends:
      * name: ''
        users: []
      ...
    followers: []
    followings: []
    watching-locations: []
    created-interesting-points: []
    watching-interesting-points: []
    unwatching-interesting-points: []
    created-interesting-point-sessions: []
    watching-interesting-point-sessions: []
    unwatching-interesting-point-sessions: []
    created-comments: []
    mentioned-interesting-points: []
    mentioned-comments: []
    mentioned-replies: []
    whispers: []
    group-chats: []
    leave-chats: []
  }


get-user-with-email = !(email, callback)->
  database.query-collection 'users', {emails: email}, callback

register = !(request-data, callback)->
  (users) <-! get-user-with-email request-data.email
  if users.length isnt 0 then
    callback new Error '邮箱已经被注册！'
  else
    user-schema = get-user-schema request-data
    database.save-single-document-in-database 'users', user-schema, callback

module.exports = !(req, res)->
  if req.body.password isnt req.body.confirm then
    res.render 'index', {title: 'Home', error-message: '两次密码不匹配！'}
  else
    (new-user) <-! register req.body
    if new-user instanceof Error then
      res.render 'index', {title: 'Home', error-message: new-user.message}
    else
      req.session.uid = new-user._id
      # res.render 'edit-profile', {user: user}
      res.render 'index', {title: 'Home', user: new-user, success-message: '注册成功！'}
