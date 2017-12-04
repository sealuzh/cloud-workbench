# Cloud WorkBench (CWB)

## Quicklinks

* Write your own benchmarks with Cloud WorkBench: https://github.com/sealuzh/cwb-benchmarks
* Install CWB: https://github.com/sealuzh/cwb-chef-repo
* *cwb* Utility Cookbook *(Chef)*: https://supermarket.chef.io/cookbooks/cwb
* *cwb* Client *(RubyGem)*: https://github.com/sealuzh/cwb
    * [Cwb::Client Docs](http://www.rubydoc.info/gems/cwb/Cwb/Client)

## Literature

* J. Scheuner, P. Leitner, J. Cito, and H. Gall, [**Cloud WorkBench – Infrastructure-as-Code Based Cloud Benchmarking,**](http://arxiv.org/pdf/1408.4565v1.pdf) in Proceedings of the 6th IEEE International Conference on Cloud Computing Technology and Science (CloudCom’14), 2014.
* J. Scheuner, J. Cito, P. Leitner, and H. Gall, [**Cloud WorkBench: Benchmarking IaaS Providers based on Infrastructure-as-Code,**](http://www.www2015.it/documents/proceedings/companion/p239.pdf) in Proceedings of the 24th International World Wide Web Conference (WWW’15) – Demo Track, 2015.
  * Screencast (previous version): https://youtu.be/0yGFGvHvobk?t=3m40s

## Studies that Used CWB

* Christian Davatz, Christian Inzinger, Joel Scheuner, and Philipp Leitner. 2017. An Approach and Case Study of Cloud Instance Type Selection for Multi-Tier Web Applications. In Proceedings of the 17th IEEE/ACM International Symposium on Cluster, Cloud and Grid Computing (CCGrid '17). IEEE Press, Piscataway, NJ, USA, 534-543. DOI: https://doi.org/10.1109/CCGRID.2017.12

* Philipp Leitner, Jürgen Cito (2016). Patterns in the Chaos - A Study of Performance Variation and Predictability in Public IaaS Clouds. ACM Transactions on Internet Technology, 16(3), pp. 15:1–15:23. New York, NY, USA.

* Joel Scheuner, Jürgen Cito, Philipp Leitner, Harald C. Gall (2015). Cloud WorkBench: Benchmarking IaaS Providers Based on Infrastructure-as-Code. In Proceedings of the 24th International Conference on World Wide Web, pp. 239–242, New York, NY, USA.

* Philipp Leitner, Joel Scheuner (2015). Bursting With Possibilities – an Empirical Study of Credit-Based Bursting Cloud Instance Types. In Proceedings of the 8th IEEE/ACM International Conference on Utility and Cloud Computing (UCC)

* Joel Scheuner, Philipp Leitner, Jürgen Cito, Harald Gall (2014). Cloud WorkBench - Infrastructure-as-Code Based Cloud Benchmarking. In Proceedings of the 6th IEEE International Conference on Cloud Computing Technology and Science (CloudCom'14)

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

Automated as part of the [installation](https://github.com/sealuzh/cwb-chef-repo#installation)
 or [manually triggerable](https://github.com/sealuzh/cwb-chef-repo#deployment).
