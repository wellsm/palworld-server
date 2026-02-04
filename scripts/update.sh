#!/bin/bash
supervisorctl stop palworld

/steamcmd/steamcmd.sh \
  +force_install_dir /palworld \
  +login anonymous \
  +app_update 2394010 validate \
  +quit

supervisorctl start palworld
