#!/usr/bin/env bash

yardman src Cargo.toml Cargo.lock 'clear && ./kill-server.sh; cargo run'
