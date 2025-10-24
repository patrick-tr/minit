FROM alpine:3 

ARG MINIT_SOURCE_DIR=bin/x86_64/

COPY ${MINIT_SOURCE_DIR}/minit /bin/minit

ENTRYPOINT [ "/bin/minit" ]
CMD [ "/bin/sh" ]