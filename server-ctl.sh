#!/bin/bash
# Wrapper untuk pwadmin Tomcat — hanya start/stop
PW_PATH=/PWServer_146

stop_all() {
    # Kill by exact binary name to avoid matching this script
    for pid in $(pgrep ./logservice 2>/dev/null); do kill -9 $pid 2>/dev/null; done
    for pid in $(pgrep ./uniquenamed 2>/dev/null); do kill -9 $pid 2>/dev/null; done
    for pid in $(pgrep "authd table" 2>/dev/null); do kill -9 $pid 2>/dev/null; done
    for pid in $(pgrep ./gamedbd 2>/dev/null); do kill -9 $pid 2>/dev/null; done
    for pid in $(pgrep ./gacd 2>/dev/null); do kill -9 $pid 2>/dev/null; done
    for pid in $(pgrep ./gfactiond 2>/dev/null); do kill -9 $pid 2>/dev/null; done
    for pid in $(pgrep ./gdeliveryd 2>/dev/null); do kill -9 $pid 2>/dev/null; done
    for pid in $(pgrep ./glinkd 2>/dev/null); do kill -9 $pid 2>/dev/null; done
    for pid in $(pgrep "./gs " 2>/dev/null); do kill -9 $pid 2>/dev/null; done
    for pid in $(pgrep "./authd" 2>/dev/null); do kill -9 $pid 2>/dev/null; done
    sync
}

start_all() {
    stop_all
    sleep 1

    cd "$PW_PATH/logservice" && nohup ./logservice logservice.conf > /dev/null 2>&1 &
    sleep 1
    cd "$PW_PATH/uniquenamed" && nohup ./uniquenamed gamesys.conf > /dev/null 2>&1 &
    sleep 1
    cd "$PW_PATH/authd" && nohup ./authd start > /dev/null 2>&1 &
    sleep 4
    cd "$PW_PATH/gamedbd" && nohup ./gamedbd gamesys.conf > /dev/null 2>&1 &
    sleep 4
    cd "$PW_PATH/gacd" && nohup ./gacd gamesys.conf > /dev/null 2>&1 &
    sleep 2
    cd "$PW_PATH/gfactiond" && nohup ./gfactiond gamesys.conf > /dev/null 2>&1 &
    sleep 2
    cd "$PW_PATH/gdeliveryd" && nohup ./gdeliveryd gamesys.conf > /dev/null 2>&1 &
    sleep 4
    cd "$PW_PATH/glinkd" && nohup ./glinkd gamesys.conf 1 > /dev/null 2>&1 &
    cd "$PW_PATH/glinkd" && nohup ./glinkd gamesys.conf 2 > /dev/null 2>&1 &
    cd "$PW_PATH/glinkd" && nohup ./glinkd gamesys.conf 3 > /dev/null 2>&1 &
    cd "$PW_PATH/glinkd" && nohup ./glinkd gamesys.conf 4 > /dev/null 2>&1 &
    sleep 4
    cd "$PW_PATH/gamed" && nohup ./gs gs01 > /dev/null 2>&1 &
}

case "$1" in
    start) start_all ;;
    stop)  stop_all ;;
esac