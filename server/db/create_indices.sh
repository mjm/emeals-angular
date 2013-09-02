#!/bin/sh

curl -XPUT http://localhost:9200/meals -d '
  "settings": {
  }
'

curl -XPUT http://localhost:9200/_river/meals/_meta -d '
{
  "type": "couchdb",
  "couchdb": {
    "host": "localhost",
    "port": 5984,
    "db": "meals",
    "filter": null
  },
  "index": {
    "index": "meals",
    "type": "meal"
  }
}'
