Jetty OpenShift DIY template
============================

This is a template for setting up a Jetty server running on an OpenShift DIY web cartridge. Forked from [marekjelen/openshift-jetty](https://github.com/marekjelen/openshift-jetty).

Prerequisites
-------------
* "*This* repository" means "Abdull/openshift-jetty"
* Let's assume you already have a Java Servlet-based application that follows a default WAR-building with Maven ("your `pom.xml`")
* In your [OpenShift Management Console](https://openshift.redhat.com/app/console/applications), add a new application of type Do-It-Yourself. 
* Clone the newly created repository to your file system. We will call this directory the "DIY checkout directory" from now on.
* Inside the DIY checkout directory, change to directory `.openshift/action_hooks` . Here, delete all files and replace them with all files you find in *this* repository's `action_hook` directory.
* Now you have to merge/copy your `pom.xml`-based, WAR-based Java Servlet project into your DIY checkout directory. Probably, you will copy a `src` directory and the `pom.xml` file.
* Edit your `pom.xml` copy inside the DIY checkout directory. Into this file, merge the information from the `pom.xml` you find in *this* repository. Probably, it suffices to add the whole `<profiles>...</profiles>` section.

Give it a try
-------------
After you have followed the above mentioned prerequisites, give your Servlet a try. Inside your local DIY checkout directory  

    git add .
    git commit -m "My first commit"
    git push

Your shell will print some output which comes via ssh from your OpenShift DIY machine. You will see how your project gets built on the remote machine. After a few seconds (depending on the time it takes your Jetty-hosted Servlet to start up), your website is served on http://diyname-yourid.rhcloud.com .

Behind the curtains
-------------------
So what is actually happening here? The Jetty Openshift DIY template plugs into the standard Openshift framework lifecycle. Let's assume you are NOT leveraging the OpenShift-hosted Jenkins Server build cartridge.  
Whenever something got pushed to your OpenShift remote repository, a git hook named `post-receive` gets executed on your remote machine. See for yourself in `~/git/diyname.git/hooks/` . Here is the gist of what's happening then.
* The OpenShift framework checks out your remote repository to the folder $OOPENSHIFT_REPO_DIR on the same machine.
* The OpenShift framework starts calling its hooks. Each hooks has an associated "user hook". These are the hooks you find in the `.openshift/action_hooks` directory of your folder.
* The user hooks exploited in *this* template are `pre_build`, `build`, `deploy`, `start`, and `stop`, in this order. 
* `pre_build`: This script checks if your machine already has a copy of Jetty. If it doesn't it will download and set up some recent version on your machine.
* `build`: This script will start Maven to build your project, using configurations that are necessary for an OpenShift environment.
* `deploy`: This script sets up an environment so that the just built Servlet can run inside a Jetty server in an OpenShift environment
* `start`: This script starts up a Jetty server serving your just built Servlet. It will also write a PID file containing the process ID which will be used by the `stop` script.
* `stop`: OpenShift will call this script whenenver OpenShift stops your machine (for instance, when you call `ctl_app stop`). It looks for the PID file written by the `start` script and use it to identify 
* the Jetty server process, then kill it.

Rationale
---------
Why does the `openshift` Maven profile build the WAR into the `deployments` directory, instead of sticking with the regular `target` directory?
* The `deploy` script creates a symlink from the Jetty `webapps` directory to the `deployments` build subdirectory. In the default Jetty configuration (as we are exploiting it in *this* repository), everything inside the Jetty `webapps` directory gets scanned by Jetty and possibly gets deployed by Jetty. Now let's imagine we would stick to constructing the WAR inside the default `target` directory. Besides the WAR there are lots of other artifacts and directories created by Maven during building in this directory. We don't want to confuse Jetty by having a bunch of JSP and class files in its serving folder. Therefore we put our final artifact, `ROOT.war`, lonely inside its own directory.

Differences from the parent repository
--------------------------------------
* *This* template doesn't depend on on-the-fly script downloading from *this* repository. This is more reliable in case Github should be down. And this is more secure in case the Github repository should be updated with malicious content (i.e. no script injection).

