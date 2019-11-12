#! /bin/bash

#
# create_cluster_file.bash
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

# This script creates a cluster file for a server or client.
# This takes the cluster file path from the FDB_CLUSTER_FILE
# environment variable, with a default of /etc/foundationdb/fdb.cluster
#
# The name of the coordinator must be defined in the FDB_COORDINATOR environment
# variable, and it must be a name that can be resolved through DNS.

function create_cluster_file() {
	FDB_CLUSTER_FILE=${FDB_CLUSTER_FILE:-/etc/foundationdb/fdb.cluster}
	echo "Using cluster file path: $FDB_CLUSTER_FILE"
	mkdir -p $(dirname $FDB_CLUSTER_FILE)

	if [[ -n "$FDB_CLUSTER_FILE_CONTENTS" ]]; then
	    echo "Writing supplied cluster file contents '$FDB_CLUSTER_FILE_CONTENTS' to cluster file $FDB_CLUSTER_FILE"
		echo "$FDB_CLUSTER_FILE_CONTENTS" > $FDB_CLUSTER_FILE
	elif [[ -n $FDB_COORDINATOR ]]; then
		#coordinator_ip=$(dig +short $FDB_COORDINATOR)
        coordinator_ip=$(dig +short $FDB_COORDINATOR)
        i=1
        while [[ (-z "$coordinator_ip") && ($i -lt 6) ]]; do
			echo "Failed $i times to look up coordinator address for $FDB_COORDINATOR, sleeping one second..." 1>&2
            sleep 1
            coordinator_ip=$(dig +short $FDB_COORDINATOR)
            i=$(($i+1))
        done
		if [[ -z "$coordinator_ip" ]]; then
			echo "Failed $i times to look up coordinator address for $FDB_COORDINATOR, exiting with result code 1" 1>&2
			exit 1
        else
            echo "Resolved coordinator '$FDB_COORDINATOR' to $coordinator_ip on try $i"
		fi
        echo "Writing generated cluster file contents 'docker:docker@$coordinator_ip:4500' to $FDB_CLUSTER_FILE"
		echo "docker:docker@$coordinator_ip:4500" > $FDB_CLUSTER_FILE
	else
		echo "FDB_COORDINATOR environment variable not defined" 1>&2
		exit 1
	fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    create_cluster_file "$@"
fi