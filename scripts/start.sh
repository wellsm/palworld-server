#!/bin/bash

/steamcmd/steamcmd.sh \
  +force_install_dir /palworld \
  +login anonymous \
  +app_update 2394010 validate \
  +quit

exec ./PalServer.sh -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS
