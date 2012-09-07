Jetty OpenShift DIY template
============================

This is a template for setting up a Jetty server running on an OpenShift DIY web cartridge. Forked from [marekjelen/openshift-jetty](https://github.com/marekjelen/openshift-jetty)

Prerequisites
-------------
* *This repository* relates to Abdull/openshift-jetty
* In your [OpenShift Management Console](https://openshift.redhat.com/app/console/applications), add a new application of type Do-It-Yourself. 
* Clone the newly created repository to your file system. We will call this directory the "DIY checkout directory" from now on.
* Inside the DIY checkout directory, change to directory .openshift/action_hooks. Here, delete the files `start` and `stop`. Replace them with the `start` and `stop` files you find in this repository's `action_hook` directory. Additionally, copy the `pre_start_diy-0.1` file.
* Now you have to merge your `pom.xml`-based, WAR-based Java Servlet project into your DIY checkout directory. Probably, you will copy a `src` directory and the `pom.xml` file.
* Edit the `pom.xml` file of your Java Servlet project. Into this file, merge the information from the `pom.xml` you find in this repository. Probably, it suffices to add the whole `<profiles>...</profiles>` section.

Give it a try
-------------
After you have followed the above mentioned prerequisites, give your Servlet a try. Inside your local DIY checkout directory  

    git add .
    git commit -m "My first commit"
    git push

Your shell will print some output which comes via ssh from your OpenShift DIY machine. You will see how your project gets built on the remote machine. After a few seconds (depending on the time it takes your Jetty-hosted Servlet to start up), your website is served on http://diyname-yourid.rhcloud.com .

Behind the curtains
-------------------