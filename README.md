# Cloud Benchmarking

# Installation

## Requirements
* Git (1.9.2)
* Vagrant (1.5.4): https://www.vagrantup.com/downloads
 * chef (11.6.2)
 * vagrant-omnibus (1.3.1)
 * [optional] vagrant-aws (0.4.1) for AWS EC2 Cloud
 * [optional] vagrant-cachier (0.7.0) for optimized local development with VirtualBox
* Required cookbooks: TODO: Berkshelf and vendored (without Berkshelf)


# Benchmarks

## Getting Started

# Limitations

* Only AWS as provider supported due to the following dependencies
  * Client side BenchmarkHelper uses AWS metadata API
	* Vagrant up does not support multiple providers
* Only single machine VM setting supported (Vagrant default VM)
* Only single AWS region supported due to fix private key in server
* No user authentication and authorization (also technical user)
* Chef cookbooks must be uploaded to the Chef server

* Log files from created VM instances are not accessible via web interface and get lost on VM shutdown
* Benchmark definition requires Chef cookbook

# Things you may want to cover

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
