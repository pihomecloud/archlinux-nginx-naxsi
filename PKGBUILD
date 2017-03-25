# Based on community/nginx-mainline

pkgname=nginx-naxsi
_naxsirelease=0.55.1
pkgver=1.11.12
pkgrel=1
pkgdesc='Lightweight HTTP server, mainline release, naxsi embedded and lot of unused flags disabled'
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
provides=('nginx')
conflicts=('nginx')
source=($url/download/nginx-$pkgver.tar.gz
        https://github.com/nbs-system/naxsi/archive/$_naxsirelease.tar.gz
        service
        logrotate)
md5sums=('c5ffbd7107c34bff4ac9446b59468e6a'
         'b894ea5327a3d102a56aeddb79d2e047'
         'ce9a06bcaf66ec4a3c4eb59b636e0dfd'
         '3441ce77cdd1aab6f0ab7e212698a8a7')

_common_flags=(
  --with-ipv6
  --with-pcre-jit
  --with-file-aio
  --with-http_gunzip_module
  --with-http_gzip_static_module
  --with-http_ssl_module
  --with-http_stub_status_module
)

_disable_flags=(
  --without-http_scgi_module
  --without-http_ssi_module
  --without-http_uwsgi_module
  --without-mail_pop3_module
  --without-mail_smtp_module
  --without-mail_imap_module
)

build() {
  cd $provides-$pkgver
  ./configure \
    --prefix=/etc/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --sbin-path=/usr/bin/nginx \
    --add-module=../naxsi-${_naxsirelease}/naxsi_src/ \
    --pid-path=/run/nginx.pid \
    --lock-path=/run/lock/nginx.lock \
    --user=http \
    --group=http \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=stderr \
    --http-client-body-temp-path=/var/lib/nginx/client-body \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    ${_common_flags[@]} \
    ${_disable_flags[@]}

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

  rmdir "$pkgdir"/run

  install -d "$pkgdir"/usr/share/man/man8/
  gzip -9c man/nginx.8 > "$pkgdir"/usr/share/man/man8/nginx.8.gz

  for i in ftdetect indent syntax; do
    install -Dm644 contrib/vim/${i}/nginx.vim \
      "${pkgdir}/usr/share/vim/vimfiles/${i}/nginx.vim"
  done

}

# vim:set ts=2 sw=2 et:
