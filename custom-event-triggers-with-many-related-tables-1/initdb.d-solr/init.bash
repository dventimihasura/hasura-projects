#!/bin/bash

set -e

/opt/solr/docker/scripts/precreate-core artist
/opt/solr/docker/scripts/precreate-core album
/opt/solr/docker/scripts/precreate-core track
/opt/solr/docker/scripts/solr-foreground


