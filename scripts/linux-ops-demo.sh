#!/usr/bin/env bash
set -euo pipefail

# Read-only Linux CLI/process/network diagnostics used in the internship demo.
# No command in this script modifies the host.

echo '== Host =='
uname -a
id
pwd

echo '== Filesystem =='
pwd
ls -la
df -h .

echo '== Processes =='
ps aux --sort=-%cpu | head -n 8

echo '== Memory =='
free -h

echo '== Network sockets =='
ss -tuln | head -n 20

echo '== Recent system log (if permitted) =='
journalctl -n 20 --no-pager 2>/dev/null || echo 'journalctl unavailable or permission denied'

echo 'Linux operations demo completed.'
