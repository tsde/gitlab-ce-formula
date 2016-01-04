=========
gitlab-ce
=========

Install and configure a Gitlab CE instance using the official Omnibus package

Prerequisite
============

On Debian make sure you have the ``apt-transport-https`` package installed. This is already the case on Ubuntu.
I didn't include this as a state requirement because I consider this package to be system-wide related rather than Gitlab related.

Available states
================

**Note**: Only the ``gitlab-ce`` state can really be used. The other states are just dependencies.

``gitlab-ce``
-------------

- Installs the ``gitlab-ce`` package
- Manages the service
- Include the ``gitlab-ce.config`` state to manage the main configuration file

``gitlab-ce.config``
--------------------

- Manages the main configuration file ``/etc/gitlab/gitlab.rb``
- Defines the ``gitlab-ctl reconfigure`` command so that it can be called when the main configuration file is updated.

``gitlab-ce.apt``
-----------------

Manages the APT repository using the official deb repository provided by Gitlab

``gitlab-ce.yum``
-----------------

Manages the YUM repository using the official rpm repository provided by Gitlab

How to use
==========

.. contents::
    :local:

States
------

As usual, in your ``top.sls``:

.. code::

  base:
    '*':
      - gitlab-ce

Pillars
-------

This formula is using two main keys ``gitlab::lookup`` and ``gitlab::conf``

``gitlab::lookup``
******************************

This key is used to override the default settings set in ``map.jinja``.
You can therefore change the filename for the APT repo file or change the service name among other settings.
You'll rarely need to override these settings.

**Note**: At the time of this writing, Gitlab only officially supports omnibus package for the following distributions:

- Debian 7 and 8
- Ubuntu 12.04 and 14.04
- RHEL/CentOS 6 and 7

You can of course use the omnibus package on other distros but you then have to choose between the previously listed repos.
For example, to install Gitlab CE on Ubuntu 15.10, use the Ubuntuu 14.04 repo by defining the ``repodist`` variable to **trusty** (this is the default provided in ``map.jinja``).

See ``pillar.example`` for possible use.

``gitlab::conf``
************************

This key represents the configuration directives that will be written to the ``/etc/gitlab/gitlab.rb`` file (See official Gitlab.rb_ file for all available options).
Configuration directives in this file comes in two forms:

- **<property>** *<value>*
- <section>['**<property>**'] = *<value>*

On one hand, directives using the first form should be written inside the ``main`` subkey as follows:

.. code::

  gitlab:
    conf:
      main:
        <property>: <value>

On the other hand, directives using the second form should be written as follows:

.. code::

  gitlab:
    conf:
      <section>:
        <property>: <value>

If you don't configure any pillar, only the **external_url** parameter will be set to **http://localhost**. This is the only parameter Gitlab needs to work out-of-the-box.

See ``pillar.example`` for concrete use.

Pillars caveat
--------------

Parameters values in the ``/etc/gitlab/gitlab.rb`` file can be of variable types:

- strings
- integers
- booleans
- objects
- arrays

The ``gitlab.rb.j2`` template has to deal with them specifically.

strings
*******

Strings will be double quoted in the generated ``/etc/gitlab/gitlab.rb`` file.

integers and booleans
*********************

no quoting will be applied, they'll appear as is in the configuration file.

objects and arrays
******************

As of now, this formula **DOES NOT** handle writing these values as plain object/array in pillars.
They're written as strings. BUT, these string shouldn't be quoted in the resulting configuration file because Gitlab has to interpret the object/array when parsing it.
Therefore, an exception exists in the template for this kind of value telling jinja not to quote them.
A limited number of section and properties use this kind of value (*gitlab_rails['ldap_servers']* for example).

Please be sure to have a look at ``pillar.example`` to see how to write them approprietly. Using the **|-** YAML syntax in your pillars can be used for better readability.

.. _Gitlab.rb: https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/files/gitlab-config-template/gitlab.rb.template
