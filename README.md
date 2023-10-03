
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Cassandra Coordinator Query Latency Causing Timeout
---

This incident type refers to an issue where the coordinator node in a Cassandra database cluster experiences slow query latency, resulting in timeouts. The coordinator node is responsible for managing client connections and routing queries to the appropriate nodes in the cluster. If it is not able to process queries quickly enough, clients may experience timeouts and be unable to retrieve the data they need. This issue can be caused by a variety of factors, including high load on the cluster, network issues, or hardware problems.

### Parameters
```shell
export KEYSPACE="PLACEHOLDER"

export TABLE="PLACEHOLDER"

export PARTITION_KEY="PLACEHOLDER"

export NODETOOL_COMMAND="PLACEHOLDER"

export PATH_TO_CASSANDRA_CONF="PLACEHOLDER"

export NEW_NODE_IP="PLACEHOLDER"

export SEED_NODE_IP="PLACEHOLDER"
```

## Debug

### Check the status of the Cassandra cluster
```shell
nodetool status
```

### List the Cassandra keyspaces to see if there are any issues with replication
```shell
cqlsh -e "DESC KEYSPACES"
```

### View the Cassandra system log to look for errors related to the coordinator node
```shell
tail -n 100 /var/log/cassandra/system.log
```

### Check the load on the Cassandra coordinator node
```shell
nodetool tpstats | grep "coordinator"
```

### Check the network latency between nodes in the Cassandra cluster
```shell
nodetool getendpoints ${KEYSPACE} ${TABLE} ${PARTITION_KEY}
```

### View the Cassandra nodetool output to see if there are any issues with the cluster
```shell
nodetool ${NODETOOL_COMMAND}
```

## Repair

### Increase the capacity of the Cassandra cluster by adding more nodes to distribute the load and reduce query latency.
```shell
bash

#!/bin/bash



# Set variables

CASSANDRA_CONF=${PATH_TO_CASSANDRA_CONF}

NEW_NODE_IP=${NEW_NODE_IP}

SEED_NODE_IP=${SEED_NODE_IP}



# Stop Cassandra

sudo service cassandra stop



# Add new node to Cassandra configuration

echo "auto_bootstrap: false" >> $CASSANDRA_CONF/cassandra.yaml

echo "seed_provider:" >> $CASSANDRA_CONF/cassandra.yaml

echo "  - class_name: org.apache.cassandra.locator.SimpleSeedProvider" >> $CASSANDRA_CONF/cassandra.yaml

echo "    parameters:" >> $CASSANDRA_CONF/cassandra.yaml

echo "      - seeds: \"$SEED_NODE_IP,$NEW_NODE_IP\"" >> $CASSANDRA_CONF/cassandra.yaml



# Start new node

sudo service cassandra start



# Check cluster status

nodetool status


```