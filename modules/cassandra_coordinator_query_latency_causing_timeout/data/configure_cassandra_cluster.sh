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