# Streamlit with OAuth2 Proxy

## セットアップ

### リポジトリをクローン

```bash
git clone https://github.com/be4rr/streamlit-oauth2proxy.git
```

### Dockerをインストール

```bash
curl -fsSL https://get.docker.com -o install-docker.sh
sudo sh install-docker.sh
sudo usermod -aG docker $USER
newgrp docker
```

### `.env`ファイルを編集

`.env.sample`の内容をコピーして`.env`を作成し，各項目を記入する．

### 証明書の発行

`docker-compose.yml`の`nginx`の部分を次のように変更する．

変更前
```yaml
    volumes:
      - ./nginx/nginx.conf.template:/etc/nginx/templates/default.conf.template
      # - ./nginx/nginx-acme.conf.template:/etc/nginx/templates/default.conf.template
```

変更後
```yaml
    volumes:
      # - ./nginx/nginx.conf.template:/etc/nginx/templates/default.conf.template
      - ./nginx/nginx-acme.conf.template:/etc/nginx/templates/default.conf.template
```

`docker compose up -d`で起動する．

次に以下のコマンドを実行することでSSL証明書を取得する．なお，このコマンドに`--dry-run`オプションを付けると動作確認できる．

```bash
docker run -it --rm \
  -v "./certbot/config:/etc/letsencrypt" \
  -v "./certbot/www:/var/www/certbot" \
  certbot/certbot certonly --webroot --webroot-path /var/www/certbot \
  -d <your domain> --agree-tos --non-interactive \
  -m <your email>
```

`docker-compose.yml`の`nginx`の部分に加えた変更をもとに戻し，再び`docker-compose up -d`を実行する．


### 証明書の自動更新

次のコマンドで証明書を更新する．`--dry-run`オプションを付けると動作確認が可能．

```bash
docker run -it --rm \
  -v "./certbot/conf:/etc/letsencrypt" \
  -v "./certbot/www:/var/www/certbot" \
  certbot/certbot renew
```

自動で証明書を更新するために上のコマンドをcronに登録する．`crontab -e`でcron tableを開き，次の行を追記する．

```bash
0 12 * * * docker run -it --rm -v "./certbot/conf:/etc/letsencrypt" -v "./certbot/www:/var/www/certbot" certbot/certbot renew
```