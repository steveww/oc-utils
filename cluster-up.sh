#!/bin/sh

PUBLIC_DNS=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)

oc cluster \
	up \
	--base-dir=$HOME/oc-cluster \
	--skip-registry-check=true \
	--public-hostname=$PUBLIC_DNS

