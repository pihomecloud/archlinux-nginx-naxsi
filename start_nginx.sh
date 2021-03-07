#!/bin/bash


if [ ! -f /etc/nginx/ssl.dhparam.pem ] && [ ! -z /etc/nginx/ssl.dhparam.pem ]
then
  echo initalizing dhparams
  openssl dhparam -out /etc/nginx/ssl.dhparam.pem 2048
fi

for domain in ${AUTOCONF_DOMAINS}
do
  root_directory="/var/www/${domain}"
  mkdir -p ${root_directory}
  echo "Disallow: *" > ${root_directory}/robots.txt
  envsubst < /etc/nginx/default_template.conf > /etc/nginx/conf.d/${domain}.conf
  touch /etc/nginx/naxsi/${domain}.whitelist.rules
done

if [ -z "${ENABLE_LETSENCRYPT}" ]
then
  exec /usr/bin/nginx -g "daemon off;"
else
  exec /bin/sh -c 'while :; do sleep 24h & wait $${!}; nginx -s reload; done & nginx -g \"daemon off;\"'
fi
