#!/usr/bin/env bash
ab -n 1000 -c 10 -p tokenize.txt -T text/plain http://127.0.0.1:8081/tokenize
