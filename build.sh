#!/bin/bash



docker build -t "coopesantos/ivr" --no-cache ivr/.
docker build -t "coopesantos/ivrgui" --no-cache webmin/.


exit 0