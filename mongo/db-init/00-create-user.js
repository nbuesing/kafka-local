db.createUser({
	user: "admin",
	pwd: "mongo",
	roles: [ { role: "readWrite", db: "admin" } ]
})

db.createCollection("DB")
