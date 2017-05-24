#!/bin/bash
/sbin/init
/usr/bin/supervisord
tail -f /dev/null
