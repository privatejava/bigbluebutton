kill -9 $(lsof -t -i:3000 -sTCP:LISTEN)
kill `ps ax | grep '[m]eteor' | awk '{print $1}'`

