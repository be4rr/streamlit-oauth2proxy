# Streamlit with OAuth2 Proxy

## Config

`.env.sample`の内容をコピーして`.env`を作成し，各項目を記入する．

## 証明書の発行

`docker-compose.yml`の`nginx`の部分で，

```yaml
    volumes:
      - ./nginx/nginx.conf.template:/etc/nginx/templates/default.conf.template
      # - ./nginx/nginx-acme.conf.template:/etc/nginx/templates/default.conf.template
```

を

```yaml
    volumes:
      # - ./nginx/nginx.conf.template:/etc/nginx/templates/default.conf.template
      - ./nginx/nginx-acme.conf.template:/etc/nginx/templates/default.conf.template
```

のように変更する．

次のコマンドを実行することでSSL証明書を取得する．

```bash
docker run -it --rm \
  -v "./certbot/config:/etc/letsencrypt" \
  -v "./certbot/www:/var/www/certbot" \
  certbot/certbot certonly --webroot --webroot-path /var/www/certbot \
  -d <your domain> --agree-tos --non-interactive \
  -m <your email>
```

`--dry-run`オプションを付けると動作確認できる．

## 証明書の更新

次のコマンドで証明書を更新できる．

```bash
docker run -it --rm \
  -v "./certbot/conf:/etc/letsencrypt" \
  -v "./certbot/www:/var/www/certbot" \
  certbot/certbot renew
```

`--dry-run`オプションを付けると動作確認できる．

自動で証明書を更新するために上のコマンドをcronに登録する．`crontab -e`でcron tableを開き，次の行を追記する．

```bash
0 12 * * * docker run -it --rm -v "./certbot/conf:/etc/letsencrypt" -v "./certbot/www:/var/www/certbot" certbot/certbot renew
```