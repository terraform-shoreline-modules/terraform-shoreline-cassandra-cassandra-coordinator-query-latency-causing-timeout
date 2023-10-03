terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "cassandra_coordinator_query_latency_causing_timeout" {
  source    = "./modules/cassandra_coordinator_query_latency_causing_timeout"

  providers = {
    shoreline = shoreline
  }
}