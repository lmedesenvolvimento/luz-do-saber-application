Instalação no CentOS

## PostgreSQL 9.4

  https://www.linode.com/docs/databases/postgresql/how-to-install-postgresql-relational-databases-on-centos-7/

  Repositório do PostgreSQL

    sudo yum install -y epel-release

  Instalação do server

    sudo yum install -y postgresql-server \
                        postgresql-devel \
                        postgresql-contrib

  Inicialização

    sudo postgresql-setup initdb
    sudo systemctl start postgresql

  Start on boot

    sudo systemctl enable postgresql

## NGINX

  https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-centos-7

  Instalação e inicialização

    sudo yum install nginx
    sudo systemctl start nginx

  Start on boot

    sudo systemctl enable nginx

  Arquivos de configuração

    /etc/nginx/conf.d

  luzdosaber.conf

    upstream puma_luzdosaber_production {
      server unix:/var/www/luzdosaber/shared/tmp/sockets/puma.sock fail_timeout=0;
    }

    server {
      listen 80;

      # server_name  _ luzdosaber.lme.ufc.br 10.44.24.63;
      server_name 10.44.24.63;

      root /var/www/luzdosaber/current/public;

      client_max_body_size 4G;
      keepalive_timeout 10;

      error_page 500 502 504 /500.html;
      error_page 503 @503;

      try_files $uri/index.html $uri @puma_luzdosaber_production;

      location @puma_luzdosaber_production {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;

        proxy_pass http://puma_luzdosaber_production;
        # limit_req zone=one;
        access_log /var/www/luzdosaber/shared/log/nginx.access.log;
        error_log /var/www/luzdosaber/shared/log/nginx.error.log;
      }

      location = /50x.html {
        root html;
      }

      location = /404.html {
        root html;
      }

      location @503 {
        error_page 405 = /system/maintenance.html;
        if (-f $document_root/system/maintenance.html) {
          rewrite ^(.*)$ /system/maintenance.html break;
        }
        rewrite ^(.*)$ /503.html break;
      }

      if ($request_method !~ ^(GET|HEAD|PUT|PATCH|POST|DELETE|OPTIONS)$ ){
        return 405;
      }

      if (-f $document_root/system/maintenance.html) {
        return 503;
      }
    }

## RVM

  Instalação

    \curl -sSL https://get.rvm.io | bash -s stable

  Instalação do Ruby

    rvm install 2.5.1

## NVM

  Instalação

    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

  NodeJs e Yarn

    nvm install nodejs
    nvm install -g yarn

## Capistrano

  Iniciando servidor:

    cap production check

  Arquivos necessários a serem colocados no ./shared

* .env
* config/database.yml

  Deploy

    cap production deploy
