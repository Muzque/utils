#!/bin/bash
# Teleport commands
set -e

function _exec() {
    cmd=${1}
    echo "Execute: ${cmd}"
    eval ${cmd}
}

function _ssh() {
    addr=${1}
    _exec "ssh -4 ${addr}"
}

function _pf() {
    addr=${1}
    port=${2}

    _exec "ssh -L ${port}:localhost:${port} -4 ${addr}"
}

function _scp() {
  addr=${1}
  filepath=${2}

  _exec "scp -4 ${filepath} ${addr}:/tmp/"
}

function usage() {
  cat <<EOUSAGE
Usage: $(basename $0) tp [-h] [-a] [-s] [-L port] [-c file]
  -a  addr          to specify ip address
  -s                to SSH
  -L  port          to SSH and port forwarding
  -c  filepath      to SCP file
  -h                to show this help
EOUSAGE
}

function main() {
    unset SCPFILE PORT ADDRESS
    DO_SSH=false
    DO_PF=false
    DO_SCP=false

    while getopts "hL:sc:a:" flag; do
        case ${flag} in
          a)  ADDRESS="${OPTARG}";;
          s)  DO_SSH=true ;;
          c)  DO_SCP=true
              SCPFILE="${OPTARG}" ;;
          L)  DO_PF=true
              PORT="${OPTARG}" ;;
          h)  usage
              exit 0 ;;
        esac
    done

    if [[ -z "${ADDRESS}" ]]; then
        echo "Please set ip address by -a argument."
        exit 1
    fi

    if [[ ${DO_SSH} == true ]]; then
      _ssh ${ADDRESS}
    elif [[ ${DO_PF} == true ]]; then
      _pf ${ADDRESS} ${PORT}
    elif [[ ${DO_SCP} == true ]]; then
      _scp ${ADDRESS} ${SCP_FILE}
    fi
}

main "$@"
