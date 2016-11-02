#!/bin/bash

C_FORCE_ROOT=1 CELERY_CONFIG_MODULE=compass.utils.celeryconfig_wrapper /usr/bin/celery worker &> /tmp/celery-worker.log
