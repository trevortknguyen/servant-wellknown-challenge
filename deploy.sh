#!/bin/bash
set -e
cabal install --install-method=copy --installdir=bin --overwrite-policy=always
heroku container:push --app $HEROKU_APPNAME web
heroku container:release --app $HEROKU_APPNAME web
