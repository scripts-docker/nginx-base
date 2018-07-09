FROM nginx:1.13.3-alpine

## Copy our nginx configc
COPY nginx/ /etc/nginx/conf.d/

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

EXPOSE 8080

### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/app-root

ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}

COPY bin/ ${APP_ROOT}/bin/

RUN chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd && \
    chgrp -R 0 /etc/nginx/ && \
    chmod -R g=u /etc/nginx/ && \
    chgrp -R 0 /var/log/nginx/ && \
    chmod -R g=u /var/log/nginx/ && \
    chgrp -R 0 /var/cache/nginx/ && \
    chmod -R g=u /var/cache/nginx/ && \
    chgrp -R 0 /var/run/ && \
    chmod -R g=u /var/run/

### Containers should NOT run as root as a good practice
USER 10001

WORKDIR ${APP_ROOT}

ENTRYPOINT [ "uid_entrypoint" ]
