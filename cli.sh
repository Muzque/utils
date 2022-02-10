#!/bin/bash
readonly SRC_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
readonly CONFIG_DIR="${SRC_ROOT}/include"
readonly UTIL_DIR="${SRC_ROOT}/src"

function main() {
  . ${CONFIG_DIR}/*.config
  ADDRESS="${username}@${ip}"
  util=${1}
  args="${@:2}"

  if [[ ! -f "${UTIL_DIR}/${util}.sh" ]]; then
      echo "Util not found: ${util}"
      exit 1
  fi

  . ${UTIL_DIR}/${util}.sh -a ${ADDRESS} ${args}
}

main "$@"
