# Based on community/nginx-mainline

pkgname=nginx-naxsi
_naxsirelease=1.3
pkgver=1.19.7
pkgrel=1
pkgdesc='Lightweight HTTP server, mainline release, naxsi embedded and lot of unused flags disabled'
arch=('i686' 'x86_64' 'armv6h' 'armv7h')
url='https://nginx.org'
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
source=($url/download/nginx-$pkgver.tar.gz{,.asc}
        https://github.com/nbs-system/naxsi/archive/$_naxsirelease.tar.gz
        service
        logrotate)
validpgpkeys=('B0F4253373F8F6F510D42178520A9993A1C052F8') # Maxim Dounin <mdounin@mdounin.ru>
md5sums=('09cd77222d59d9bd8168b788a80f5ef2'
         'SKIP'
         'cf4000d79d0259852fbadddc1f32518f'
         'ce9a06bcaf66ec4a3c4eb59b636e0dfd'
         '3441ce77cdd1aab6f0ab7e212698a8a7')
sha512sums=('660f03533581f350bbfe9a519fd0ee59c543c78be98aa5287df20a89653545b29fc98282548eab1741fb1d5c26da140166b6712ee06e498ba518019588f9b747'
            'SKIP'
            'd7aac69b5eceeb1b0db4741201159ade1e0e7f6f7c3e8c4afa2f8959c6c00c3b5285d5185747c2fb0b1400efda02e96799836315e7e492bb4a059b14acb2142d'
            '7dffe1067ea52ed69bc6dd95c4286af3b6dd13821df64d4a209b39bc5b4b46bc40566d4783695a3527ec640436e2b5e84edd41d547c3bc3ac2ef5e043bd88d66'
            '57298ccaac36e2fd96cbdffeef990dcb70b80f85634e6498b878c8caeb764568a23619797a6c1548f8296e2fb0fd59c9b2f752a7844cfa200e4534fd9fbcf735')

_common_flags=(
  --with-file-aio
  --with-http_gunzip_module
  --with-http_gzip_static_module
  --with-http_ssl_module
  --with-http_stub_status_module
  --with-http_v2_module
  --with-pcre-jit
  --with-threads
)

_disable_flags=(
  --without-http_ssi_module
  --without-http_autoindex_module
  --without-http_geo_module
  --without-http_split_clients_module
  --without-http_scgi_module
  --without-http_uwsgi_module
  --without-http_memcached_module
  --without-http-cache
  --without-mail_pop3_module
  --without-mail_imap_module
  --without-mail_smtp_module
)

build() {
  cd $provides-$pkgver
  ./configure \
    --prefix=/etc/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --sbin-path=/usr/bin/nginx \
    --add-dynamic-module=../naxsi-${_naxsirelease}/naxsi_src/ \
    --pid-path=/run/nginx.pid \
    --lock-path=/run/lock/nginx.lock \
    --user=http \
    --group=http \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=stderr \
    --http-client-body-temp-path=/var/lib/nginx/client-body \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --with-cc-opt="$CFLAGS $CPPFLAGS" \
    --with-ld-opt="$LDFLAGS" \
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
