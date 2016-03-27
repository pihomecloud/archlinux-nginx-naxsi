# Based on community/nginx

pkgname=nginx-naxsi
_naxsirelease=0.54
provides=('nginx')
conflicts=('nginx')
pkgver=1.9.10
pkgrel=2
pkgdesc='Lightweight HTTP server and IMAP/POP3 proxy server, mainline release'
arch=('i686' 'x86_64' 'armv6h' 'armv7h')
url='http://nginx.org'
license=('custom')
depends=('pcre' 'zlib' 'openssl')
backup=('etc/nginx/fastcgi.conf'
        'etc/nginx/fastcgi_params'
        'etc/nginx/koi-win'
        'etc/nginx/koi-utf'
        'etc/nginx/mime.types'
        'etc/nginx/nginx.conf'
        'etc/nginx/scgi_params'
        'etc/nginx/uwsgi_params'
        'etc/nginx/win-utf'
        'etc/logrotate.d/nginx')
install=nginx.install
source=($url/download/nginx-$pkgver.tar.gz
        https://github.com/nbs-system/naxsi/archive/$_naxsirelease.tar.gz
        service
        logrotate)
md5sums=('64cc970988356a5e0fc4fcd1ab84fe57'
         '1bc31058991268e4cfdb44e9b6d8b3b3'
         'ce9a06bcaf66ec4a3c4eb59b636e0dfd'
         '3441ce77cdd1aab6f0ab7e212698a8a7')

build() {
  cd $provides-$pkgver
  ./configure \
    --prefix=/etc/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --sbin-path=/usr/bin/nginx \
    --add-module=../naxsi-0.54/naxsi_src/ \
    --pid-path=/run/nginx.pid \
    --lock-path=/run/lock/nginx.lock \
    --user=http \
    --group=http \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log \
    --http-client-body-temp-path=/var/lib/nginx/client-body \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --without-http_scgi_module \
    --without-http_uwsgi_module \
    --without-mail_pop3_module \
    --without-mail_smtp_module \
    --without-mail_imap_module \
    --with-ipv6 \
    --with-pcre-jit \
    --with-http_dav_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --without-http_ssi_module
  make
}

package() {
  cd $provides-$pkgver
  make DESTDIR="$pkgdir" install

  sed -e 's|\<user\s\+\w\+;|user http;|g' \
    -e '44s|html|/usr/share/nginx/html|' \
    -e '54s|html|/usr/share/nginx/html|' \
    -i "$pkgdir"/etc/nginx/nginx.conf

  rm "$pkgdir"/etc/nginx/*.default

  install -d "$pkgdir"/var/lib/nginx
  install -dm700 "$pkgdir"/var/lib/nginx/proxy

  chmod 750 "$pkgdir"/var/log/nginx
  chown http:log "$pkgdir"/var/log/nginx

  install -d "$pkgdir"/usr/share/nginx
  mv "$pkgdir"/etc/nginx/html/ "$pkgdir"/usr/share/nginx

  install -Dm644 ../logrotate "$pkgdir"/etc/logrotate.d/nginx
  install -Dm644 ../service "$pkgdir"/usr/lib/systemd/system/nginx.service
  install -Dm644 LICENSE "$pkgdir"/usr/share/licenses/$provides/LICENSE
  for i in ftdetect indent syntax; do
    install -Dm644 contrib/vim/${i}/nginx.vim "${pkgdir}/usr/share/vim/vimfiles/${i}/nginx.vim"
  done


  rmdir "$pkgdir"/run
}

# vim:set ts=2 sw=2 et:
