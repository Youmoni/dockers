#! /bin/bash

#
# create_server_environment.bash
#
# This source file is part of the FoundationDB open source project
#
# Copyright 2013-2018 Apple Inc. and the FoundationDB project authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

source /var/fdb/scripts/create_cluster_file.bash

function create_server_environment() {
	fdb_dir=/var/fdb
	env_file=$fdb_dir/.fdbenv

	: > $env_file

    echo "Wrote environment to $env_file: $(cat $env_file)"

	if [[ "$FDB_NETWORKING_MODE" == "host" ]]; then
		public_ip=127.0.0.1
        echo "Using 'host' networking mode, public ip set to $public_ip"
	elif [[ "$FDB_NETWORKING_MODE" == "container" ]]; then
		public_ip=$(grep `hostname` /etc/hosts | sed -e "s/\s *`hostname`.*//")
        echo "Using 'container' networking mode, public ip set to $public_ip"
	else
		echo "Unknown FDB Networking mode \"$FDB_NETWORKING_MODE\"" 1>&2
		exit 1
	fi

	#echo "export PUBLIC_IP=$public_ip" >> $env_file
	echo "export PUBLIC_IP=auto" >> $env_file
    echo "Exported PUBLIC_IP=$public_ip"
	if [[ -z $FDB_COORDINATOR ]]; then
		FDB_CLUSTER_FILE_CONTENTS="docker:docker@$public_ip:$FDB_PORT"
        echo "Setting FDB_CLUSTER_FILE_CONTENTS to '$FDB_CLUSTER_FILE_CONTENTS'"
	fi

	create_cluster_file
}