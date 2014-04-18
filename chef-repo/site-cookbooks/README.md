This directory contains unmodified 3rd party cookbooks downloaded from the Opscode Cookbook Site http://community.opscode.com/cookbooks or other sources. Do not store any modified cookbooks here. Use the application- or wrapper-cookbook approach describes in the official Opscode blog http://www.getchef.com/blog/2013/12/03/doing-wrapper-cookbooks-right/


To install a cookbook from the Opscode Cookbook Site use the following command:

    knife cookbook site install COOKBOOK

This will:

* Download the cookbook tarball from cookbooks.opscode.com.
* Ensure its on the git master branch.
* Checks for an existing vendor branch, and creates if it doesn't.
* Checks out the vendor branch (chef-vendor-COOKBOOK).
* Removes the existing (old) version.
* Untars the cookbook tarball it downloaded in the first step.
* Adds the cookbook files to the git index and commits.
* Creates a tag for the version downloaded.
* Checks out the master branch again.
* Merges the cookbook into master.
* Repeats the above for all the cookbooks dependencies, downloading them from the community site
