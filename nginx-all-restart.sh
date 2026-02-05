echo sudo systemctl restart alog-bori.service
sudo systemctl restart alog-bori.service

echo sudo systemctl restart alog-test.service
sudo systemctl restart alog-test.service

echo sudo systemctl restart alog-half.service
sudo systemctl restart alog-half.service

echo sudo systemctl restart nginx
sudo systemctl restart nginx

cd /home/ec2-user/alog/alog-bori && /usr/bin/python3 alog_ga_app/sendmail.py nginx-all-restart "<span style='color: blue;'>⭕</span> OK "

