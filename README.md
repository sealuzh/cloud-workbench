# Cloud WorkBench (CWB)

## Quicklinks

* Write your own benchmarks with Cloud WorkBench: https://github.com/sealuzh/cwb-benchmarks
* Install CWB: https://github.com/sealuzh/cwb-chef-repo
* *cwb* Utility Cookbook *(Chef)*: https://supermarket.chef.io/cookbooks/cwb
* *cwb* Client *(RubyGem)*: https://github.com/sealuzh/cwb
    * [Cwb::Client Docs](http://www.rubydoc.info/gems/cwb/Cwb/Client)

## Literature

* J. Scheuner, P. Leitner, J. Cito, and H. Gall, [**Cloud WorkBench – Infrastructure-as-Code Based Cloud Benchmarking,**](http://arxiv.org/pdf/1408.4565v1.pdf) in Proceedings of the 6th IEEE International Conference on Cloud Computing Technology and Science (CloudCom’14), 2014.
* J. Scheuner, J. Cito, P. Leitner, and H. Gall, [**Cloud WorkBench: Benchmarking IaaS Providers based on Infrastructure-as-Code,**](http://wp.ifi.uzh.ch/preprints/demo10-scheunerATS.pdf) in Proceedings of the 24th International World Wide Web Conference (WWW’15) – Demo Track, 2015.
  * Screencast (previous version): https://youtu.be/0yGFGvHvobk?t=3m40s

## Screenshots

![Benchmark Definition](/docs/img/cwb-edit-benchmark.png?raw=true "Edit Benchmark Definition")

![Benchmark Execution](/docs/img/cwb-show-execution.png?raw=true "Show Benchmark Execution")

## Installation

> Interested in your own Cloud WorkBench installation?<br>
> Feel free to contact us: leitner[AT]ifi.uzh.ch or joel.scheuner[AT]uzh.ch

Most parts are automated and configurable via [Chef](https://www.chef.io/),
some manual steps are required to setup credentials and Chef server configuration.

Step-by-step guidance is given here: https://github.com/sealuzh/cwb-chef-repo

## Deployment

Automated as part of the [installation](https://github.com/sealuzh/cwb-chef-repo#Installation)
 or [manually triggerable](https://github.com/sealuzh/cwb-chef-repo#Deployment).
