#!/bin/bash
set -e

rm -f /tmp/.X99-lock

# dbus-daemon --system

sudo mkdir -p /run/user/$(id -u) && sudo chown $(whoami):$(groups | cut '-d ''-''f2') /run/user/* 

export XDG_RUNTIME_DIR=/run/user/$(id -u)

dbus-daemon \
    --session \
    --address=unix:path=$XDG_RUNTIME_DIR/bus \
    --fork

Xorg \
    :99 \
    -noreset \
    -nolisten tcp \
    -config /etc/X11/xorg.conf &

sleep 3

USER_NAME=$(id -un)


google-chrome \
      --remote-debugging-address=0.0.0.0 \
      --remote-debugging-port=9222 \
      --user-data-dir=/home/$USER_NAME/chrome-profile \
      --profile-directory=Default \
      --window-size=1920,1080 \
      --no-first-run \
      --no-default-browser-check &

CHROME_PID=$!

until curl -fs http://127.0.0.1:9222/json/version >/dev/null; do
    sleep 0.2
done

socat TCP-LISTEN:9223,fork,reuseaddr TCP:127.0.0.1:9222 &

# Keep the container running — wait for Chrome to exit
wait $CHROME_PID


