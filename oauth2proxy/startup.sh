envsubst < /etc/oauth2proxy.conf.template > /etc/oauth2proxy.conf
/usr/local/bin/oauth2-proxy --config /etc/oauth2proxy.conf