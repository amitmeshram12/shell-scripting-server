sudo apt-get update
sudo apt-get install nginx -y

sudo unlink /etc/nginx/sites-enabled/default 

cd etc/nginx/sites-available/

vi reverse-proxy.conf

server {
    listen 80;
    
    Server_name www.amazone.com;
    location / {
        proxy_pass http://127.0.0.1;
    }
}

:qw!

sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf

service nginx configtest

service nginx restart