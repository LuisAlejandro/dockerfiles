#!/usr/bin/env bash
#
#   This file is part of Dockershelf.
#   Copyright (C) 2016, Dockershelf Developers.
#
#   Please refer to AUTHORS.rst for a complete list of Copyright holders.
#
#   Dockershelf is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   Dockershelf is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see http://www.gnu.org/licenses.

set -e

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_IMAGE_NAME="${1}"

source "${BASEDIR}/library.sh"

if [ -z "${DOCKER_IMAGE_NAME}" ]; then
    msgerror "No Docker image name was given. Aborting."
    exit 1
fi

DOCKER_IMAGE_TARGET="$( echo ${DOCKER_IMAGE_NAME%%:*} | awk -F'/' '{print toupper($2)}' )"
MB_CURRENT_API_END="$( eval 'echo ${MB_'"${DOCKER_IMAGE_TARGET}"'_API_END}' )"

cmdretry curl -H 'Content-Type: application/json' --data '{update: true}' -X POST ${MB_CURRENT_API_END}
cmdretry docker login --username ${DH_USERNAME} --password ${DH_PASSWORD} >/dev/null 2>&1
cmdretry docker push ${DOCKER_IMAGE_NAME}