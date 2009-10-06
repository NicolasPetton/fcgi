#! /bin/bash

gst-package -t ~/.st ./package.xml

echo "PackageLoader fileInPackage: 'FCGI'. FCGI.FCGIServer new port: 9001; open" | gst
