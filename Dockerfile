from archlinux:latest AS build

RUN pacman -Syu --noconfirm base-devel git sudo gnupg

RUN useradd -m -u 1000 builduser

COPY PKGBUILD logrotate nginx.install service /ng_build/
RUN chown -R builduser /ng_build \
    && sudo -su builduser bash -c 'gpg --recv-key 520A9993A1C052F8 && cd /ng_build && makepkg' \
    && mv /ng_build/nginx-naxsi-*.pkg.tar.zst /ng_build/nginx-naxsi.pkg.tar.zst

RUN chown root: /ng_build/nginx-naxsi.pkg.tar.zst \
    && chmod 666 /ng_build/nginx-naxsi.pkg.tar.zst

from archlinux:latest

COPY --from=build /ng_build/nginx-naxsi.pkg.tar.zst /tmp/
COPY nginx.conf helpers/default_headers.conf helpers/default_ssl.conf helpers/default_template.conf /etc/nginx/
COPY start_nginx.sh /start_nginx.sh


RUN pacman -Syu --noconfirm pcre zlib openssl \
    && pacman --noconfirm -U /tmp/nginx-naxsi.pkg.tar.zst \
    && rm /tmp/nginx-naxsi.pkg.tar.zst \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && touch /etc/nginx/ssl.dhparam.pem \
    && chmod 0600 /etc/nginx/ssl.dhparam.pem \
    && chmod +x /start_nginx.sh

CMD /start_nginx.sh
