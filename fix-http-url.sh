#!/bin/sh

find _posts/ -type f -exec sed -i 's/http:\/\/blog.toonormal.com//g' {} \;
