# mockable Singleton
require! ['mongodb'.Db, 'mongodb'.Server, 'mongodb'.MongoClient, 'mongodb'.ObjectID, './config']

db = null

init-mongo-client = !(callback)->
  if db
    callback!
  else
    # debug "create connection"
    db := new Db config.mongo.db, (new Server config.mongo.host, config.mongo.port), w: config.mongo.write-concern
    (err, db) <-! db.open

    load-collections db, config.mongo.collections
    callback!

load-collections = !(db, collections)->
  db.at-plus = {}
  for c in collections
    # debug "add collection: #{c} in db"
    let collection-name = c # 这里要用闭包来保证创建collection的正确
      db.at-plus[collection-name] = db.collection collection-name

shutdown-mongo-client = !(callback)->
  db.close!
  db := null
  callback!

__set-mock-db = !(mock-db)->
  db = mock-db

get-db = !(callback)->
  if !db
    <-! init-mongo-client
    callback db
  else
    callback db

query-collection = !(collection-name, query-obj, callback)->
  (db) <-! get-db
  (err, results) <-! db.at-plus[collection-name].find query-obj .to-array
  throw err if err
  callback results

save-single-document-in-database = !(collection-name, single-doc, callback)->
  (db) <-! get-db
  (err, results) <-! db.at-plus[collection-name].insert single-doc, {safe: true}
  throw err if err
  callback results[0]

find-and-modify = !(collection-name, criteria, update, callback)->
  (db) <-! get-db
  (err, updated-obj) <-! db.at-plus[collection-name].find-and-modify criteria, {}, update, {new: true}
  throw err if err
  callback updated-obj

query-collection-with-options = !(collection-name, query-obj, options, callback)->
  (db) <-! get-db
  (err, results) <-! db.at-plus[collection-name].find query-obj, options .to-array
  throw err if err
  callback results

get-collection-count = !(collection-name, query-obj, callback)->
  (db) <-! get-db
  (err, cursor) <-! db.at-plus[collection-name].find query-obj
  throw err if err
  (err, count)<-! cursor.count
  throw err if err
  callback count

update-collection = !(collection-name, query-obj, update-obj, callback)->
  (db) <-! get-db
  (err, count) <-! db.at-plus[collection-name].update query-obj, update-obj, {safe: true, multi: true}
  throw err if err
  callback count

remove = !(collection-name, query-obj, callback)->
  (db) <-! get-db
  (err, count) <-! db.at-plus[collection-name].remove query-obj, {safe: true}
  throw err if err
  callback count

module.exports =
  get-db: get-db
  shutdown-mongo-client: shutdown-mongo-client
  query-collection: query-collection
  ObjectId: ObjectID
  save-single-document-in-database: save-single-document-in-database
  find-and-modify: find-and-modify
  query-collection-with-options: query-collection-with-options
  get-collection-count: get-collection-count
  update-collection: update-collection
  remove: remove


