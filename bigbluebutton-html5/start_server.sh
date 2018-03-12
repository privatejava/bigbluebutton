ENVIRONMENT_TYPE=production

export METEOR_SETTINGS=$(cat programs/server/assets/app/config/settings-production.json)

# clear any old collections from the database
mongo html5client --eval "printjson(db.dropDatabase())"

cd /usr/share/meteor/bundle
ROOT_URL=http://127.0.0.1/html5client MONGO_URL=mongodb://localhost:27017/html5client NODE_ENV=$ENVIRONMENT_TYPE PORT=3000 node main.js


# npm start:prod


