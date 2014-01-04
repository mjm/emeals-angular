FROM mmoriarity/nodejs
ADD . /src
RUN cd /src; npm install
ENV NODE_ENV production
EXPOSE 5000
VOLUME ["/src"]
ENTRYPOINT ["/usr/bin/coffee", "/src/app.coffee"]
