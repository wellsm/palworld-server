#!/bin/bash
pkill -SIGINT PalServer
sleep 10
supervisorctl start palworld
