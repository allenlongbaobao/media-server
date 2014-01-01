require! ['JSV' .JSV]

default-schema =
  type: 'object'
  additional-properties: false

register-schema =
  type: 'object'
  additional-properties: false
  properties:
    email:
      description: '注册的邮箱'
      type: 'string'
      format: 'email'
      required: true
    password:
      description: '注册的密码'
      type: 'string'
      min-length: 6
      required: true
    username:
      description: '用户名'
      type: 'string'
      min-length: 1
      required: true
    confirm:
      description: '确认密码'
      type: 'string'
      min-length: 6
      required: true

login-schema =
  type: 'object'
  additional-properties: false
  properties:
    email:
      description: '登陆的邮箱'
      type: 'string'
      format: 'email'
      required: true
    password:
      description: '登陆的密码'
      type: 'string'
      required: true

upload-avatar-schema =
  type: 'object' additional-properties: false
  # properties:
  #   cropwidth:
  #     description: '图片宽度'
  #     type: 'string'
  #     required: true
  #   cropheight:
  #     description: '图片高度'
  #     type: 'string'
  #     required: true
  #   width:
  #     description: '图片宽度'
  #     type: 'string'
  #     required: true
  #   height:
  #     description: '图片高度'
  #     type: 'string'
  #     required: true
  #   y:
  #     description: '开始点纵坐标'
  #     type: 'string'
  #     required: true
  #   x:
  #     description: '开始点横坐标'
  #     type: 'string'
  #     required: true

update-profile-schema =
  type: 'object'
  additional-properties: false
  properties:
    gender:
      type: 'string'
      enum: ['U', 'M', 'F']
      required: true
    username:
      type: 'string'
      min-length: 1
      required: true
    signature:
      type: 'string'
      required: true

audio-upload-schema =
  type: 'object'
  additional-properties: false
  properties:
    user-id:
      type: 'string'
      required: true

schemas =
  'register': register-schema
  'login': login-schema
  'upload_avatar': upload-avatar-schema
  'update_profile': update-profile-schema
  'upload_audio': audio-upload-schema

get-schema-with-request-param = (request-param)->
  schemas[request-param] or default-schema

module.exports = !(req, res, next)->
  schema = get-schema-with-request-param req.params[0].slice 1
  env = JSV.create-environment!
  report = env.validate req.body, schema
  if report.errors.length is 0 then next!
  else
    res.render 'error', {errors: report.errors}
