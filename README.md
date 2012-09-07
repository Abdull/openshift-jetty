Jetty OpenShift DIY template
============================

This is a template for setting up a Jetty server running on an OpenShift DIY web cartridge. Forked from [marekjelen/openshift-jetty](https://github.com/marekjelen/openshift-jetty)

Prerequisites
-------------

* In your [OpenShift Management Console](https://openshift.redhat.com/app/console/applications), add a new application of type Do-It-Yourself. 
* Clone the newly created repository to your file system.
* Inside this newly cloned folder, change to directory .openshift/action_hooks. Here, delete the files `start` and `stop`. Replace them with the `start` and `stop` files you find in this repository's `action_hook` directory. Additionally, copy the `pre_start_diy-0.1` file.
* Now you have to merge your `pom.xml`-based, WAR-based Java servlet project into your repository. Probably, it's a `src` directory and the `pom.xml` file.
* Edit the `pom.xml` file of your Java servlet project. Into this file, merge the information from the `pom.xml` you find in this repository. Probably, it suffices to add the whole `profiles` section.