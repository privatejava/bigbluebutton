npm install --production
rm -rf ../output/bigbluebutton-html5.tar.gz
meteor build ../output --architecture os.linux.x86_64
sh kill_server.sh
tar xvf ../output/bigbluebutton-html5.tar.gz -C ../output/
cp *.sh ../output/bundle
#sh start_server.sh &

