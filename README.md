Simple Ghost Blog Puppet module
===============================

This is a simple module inteded to install Ghost in a quick and easy way.

Requirements
------------

* Node/npm
  * This module **assumes that your machine has already installed** `node` and `npm`
  so you need to take care of that part.
  * There's also a [`simple-node-puppet-module`](https://github.com/AAlvz/simple-node-puppet-module) you can use to take care of this task.
* [Nginx](https://github.com/jfryman/puppet-nginx)
  * The [`puppet-nginx`](https://github.com/jfryman/puppet-nginx) module has to be
    present as well. (To forward Ghost to port 80)

Usage
-----

Just call the class, for example in your default node:

`manifests/site.pp`

```
node default {
  # Node should be installed already! ->
  class { 'aalvz_ghost': }
}
```

If you're using the [`simple-node-puppet-module`](https://github.com/AAlvz/simple-node-puppet-module), it'd be like this:

```
node default {
  class { 'aalvz_node': }  ->
  class { 'aalvz_ghost': }
}
```

The same, using hiera would be:

```
---
classes:
  - aalvz_node
  - aalvz_ghost
```

As commented before, you need to make sure that npm is installed in a compatible
version with ghost (0.10.x)

Support
-------

This has been tested on:

  * Debian Jessie.

Improvements
------------

Feel free to open any issue/pull-request if you see useful improvements.
K.I.S.S.
