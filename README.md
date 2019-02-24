Cloud WorkBench (CWB) [![Build Status](https://travis-ci.org/sealuzh/cloud-workbench.svg?branch=master)](https://travis-ci.org/sealuzh/cloud-workbench)
[![Coverage Status](https://coveralls.io/repos/github/sealuzh/cloud-workbench/badge.svg?branch=master)](https://coveralls.io/github/sealuzh/cloud-workbench?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/fd2aa0193647f862d92e/maintainability)](https://codeclimate.com/github/sealuzh/cloud-workbench/maintainability)
=========

## Quicklinks

* Write your own benchmarks with Cloud WorkBench: https://github.com/sealuzh/cwb-benchmarks
* Install CWB: https://github.com/sealuzh/cwb-chef-repo
* *cwb* Utility Cookbook *(Chef)*: https://supermarket.chef.io/cookbooks/cwb
* *cwb* Client *(RubyGem)*: https://github.com/sealuzh/cwb
  * [Cwb::Client Docs](http://www.rubydoc.info/gems/cwb/Cwb/Client)

## Literature

* Joel Scheuner, Philipp Leitner, Jürgen Cito, and Harald Gall (2014), [**Cloud WorkBench – Infrastructure-as-Code Based Cloud Benchmarking,**](http://arxiv.org/pdf/1408.4565v1.pdf) in Proceedings of the 6th IEEE International Conference on Cloud Computing Technology and Science (CloudCom’14), 2014. DOI: https://doi.org/10.1109/CloudCom.2014.98
* Joel Scheuner, Jürgen Cito, Philipp Leitner, and Harald Gall (2015), [**Cloud WorkBench: Benchmarking IaaS Providers based on Infrastructure-as-Code,**](http://www.www2015.it/documents/proceedings/companion/p239.pdf) in Proceedings of the 24th International World Wide Web Conference (WWW’15) – Demo Track, 2015. DOI: https://doi.org/10.1145/2740908.2742833
  * Screencast (previous version): https://youtu.be/0yGFGvHvobk?t=3m40s

## Studies that Used CWB

* Christoph Laaber, Joel Scheuner, Philipp Leitner (2019), [**Performance testing in the cloud. How bad is it really?**](#) Empirical Software Engineering Journal (EMSE’19), 2019. DOI: http://dx.doi.org/10.1007/s10664-019-09681-1 (to appear) [preprint](http://t.uzh.ch/T4)

* Joel Scheuner, Philipp Leitner (2018). [**Estimating Cloud Application Performance Based on Micro-Benchmark Profiling**](https://research.chalmers.se/publication/504868/file/504868_Fulltext.pdf) in Proceedings of the 11th  IEEE International Conference on Cloud Computing (CLOUD'18). DOI: https://doi.org/10.1109/CLOUD.2018.00019

* Joel Scheuner, Philipp Leitner (2018). [**A Cloud Benchmark Suite Combining Micro and Applications Benchmarks**](https://research.chalmers.se/publication/502659/file/502659_Fulltext.pdf), in Proceedings of the 4th International Workshop on Quality-Aware DevOps (QUDOS'18@ICPE). DOI: https://doi.org/10.1145/3185768.3186286

* Christian Davatz, Christian Inzinger, Joel Scheuner, and Philipp Leitner (2017). [**An Approach and Case Study of Cloud Instance Type Selection for Multi-Tier Web Applications.**](https://pdfs.semanticscholar.org/82c8/3bc10bc34ae0e67bae2996c6055f27433826.pdf) in Proceedings of the 17th IEEE/ACM International Symposium on Cluster, Cloud and Grid Computing (CCGrid'17). IEEE Press, Piscataway, NJ, USA, 534-543. DOI: https://doi.org/10.1109/CCGRID.2017.12

* Philipp Leitner, Jürgen Cito (2016). [**Patterns in the Chaos - A Study of Performance Variation and Predictability in Public IaaS Clouds**](https://arxiv.org/pdf/1411.2429v2.pdf). ACM Transactions on Internet Technology, 16(3), pp. 15:1–15:23. New York, NY, USA. DOI: https://doi.org/10.1145/2885497

* Joel Scheuner, Jürgen Cito, Philipp Leitner, and Harald Gall (2015), [**Cloud WorkBench: Benchmarking IaaS Providers based on Infrastructure-as-Code,**](http://www.www2015.it/documents/proceedings/companion/p239.pdf) in Proceedings of the 24th International World Wide Web Conference (WWW’15) – Demo Track, 2015. DOI: https://doi.org/10.1145/2740908.2742833

* Philipp Leitner, Joel Scheuner (2015). [**Bursting With Possibilities – an Empirical Study of Credit-Based Bursting Cloud Instance Types.**](http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7431414) In Proceedings of the 8th IEEE/ACM International Conference on Utility and Cloud Computing (UCC). DOI: https://doi.org/10.1109/UCC.2015.39

* Joel Scheuner, Philipp Leitner, Jürgen Cito, and Harald Gall (2014), [**Cloud WorkBench – Infrastructure-as-Code Based Cloud Benchmarking,**](http://arxiv.org/pdf/1408.4565v1.pdf) in Proceedings of the 6th IEEE International Conference on Cloud Computing Technology and Science (CloudCom’14), 2014. DOI: https://doi.org/10.1109/CloudCom.2014.98

## Screenshots

![Benchmark Definition](/docs/img/cwb-edit-benchmark.png?raw=true "Edit Benchmark Definition")

![Benchmark Execution](/docs/img/cwb-show-execution.png?raw=true "Show Benchmark Execution")

Find more screenshots under [/docs/img](/docs/img)

## Installation

> Interested in your own Cloud WorkBench installation?<br>
> Feel free to contact us: philipp.leitner[AT]chalmers.se or scheuner[AT]chalmers.se

Most parts are automated and configurable via [Chef](https://www.chef.io/),
some manual steps are required to setup credentials and Chef server configuration.

Step-by-step guidance is given [here](https://github.com/sealuzh/cwb-chef-repo)

## Deployment

Automated as part of the [installation](https://github.com/sealuzh/cwb-chef-repo#installation)
 or [manually triggerable](https://github.com/sealuzh/cwb-chef-repo#deployment).

## Development

See [DEVELOPMENT.md](./DEVELOPMENT.md)
