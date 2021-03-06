#!/bin/bash

cd / && tar -xf /broker.tar.gz && rm broker.tar.gz
chmod +x /broker/init.sh
/bin/bash -c /broker/init.sh

while getopts ":u:p:e:" opt; do
  case $opt in
    u)
      echo "-u was triggered, Parameter: $OPTARG" >&2
      echo $OPTARG >  /google_cred
      ;;
    p)
      echo "-p was triggered, Parameter: $OPTARG" >&2
      echo $OPTARG >> /google_cred
      ;;
    e)
      echo "-e was triggered, Parameter: $OPTARG" >&2
      echo $OPTARG >> /google_cred
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

if [ ! -e /broker/db.sqlite3 ]; then
  cd /broker && python manage.py syncdb --noinput
fi
cd /broker/ && nohup python manage.py runserver 0.0.0.0:8000 &
