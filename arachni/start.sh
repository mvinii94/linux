#!/bin/bash
nohup /opt/arachni/bin/arachni_web -o 0.0.0.0 -p 8080 &
nohup /opt/arachni/bin/arachni_rest_server &
