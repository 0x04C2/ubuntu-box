#!/usr/bin/env bash
#
# change timezone to Asia/Shanghai

# change_timezone changes UTC to Asia/Shanghai.
#
# NOTE: `timedatectl list-timezones` list all timezones.
change_timezone() {
  sudo timedatectl set-timezone Asia/Shanghai
}

main() {
  change_timezone
}

main
