resource "shoreline_notebook" "cassandra_coordinator_query_latency_causing_timeout" {
  name       = "cassandra_coordinator_query_latency_causing_timeout"
  data       = file("${path.module}/data/cassandra_coordinator_query_latency_causing_timeout.json")
  depends_on = [shoreline_action.invoke_configure_cassandra_cluster]
}

resource "shoreline_file" "configure_cassandra_cluster" {
  name             = "configure_cassandra_cluster"
  input_file       = "${path.module}/data/configure_cassandra_cluster.sh"
  md5              = filemd5("${path.module}/data/configure_cassandra_cluster.sh")
  description      = "Increase the capacity of the Cassandra cluster by adding more nodes to distribute the load and reduce query latency."
  destination_path = "/agent/scripts/configure_cassandra_cluster.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_configure_cassandra_cluster" {
  name        = "invoke_configure_cassandra_cluster"
  description = "Increase the capacity of the Cassandra cluster by adding more nodes to distribute the load and reduce query latency."
  command     = "`chmod +x /agent/scripts/configure_cassandra_cluster.sh && /agent/scripts/configure_cassandra_cluster.sh`"
  params      = ["PATH_TO_CASSANDRA_CONF","NEW_NODE_IP","SEED_NODE_IP"]
  file_deps   = ["configure_cassandra_cluster"]
  enabled     = true
  depends_on  = [shoreline_file.configure_cassandra_cluster]
}

