Jetty OpenShift DIY template
============================

This is a template for setting up a Jetty server running on an OpenShift DIY web cartridge. Forked from [marekjelen/openshift-jetty](https://github.com/marekjelen/openshift-jetty).

Prerequisites
-------------
* "*This* repository" means "Abdull/openshift-jetty"
* In your [OpenShift Management Console](https://openshift.redhat.com/app/console/applications), add a new application of type Do-It-Yourself. 
* Clone the newly created repository to your file system. We will call this directory the "DIY checkout directory" from now on.
* Inside the DIY checkout directory, change to directory `.openshift/action_hooks` . Here, delete the files `start` and `stop`. Replace them with the `start` and `stop` files you find in *this* repository's `action_hook` directory. Additionally, copy the `pre_start_diy-0.1` file.
* Now you have to merge your `pom.xml`-based, WAR-based Java Servlet project into your DIY checkout directory. Probably, you will copy a `src` directory and the `pom.xml` file.
* Edit the `pom.xml` file of your Java Servlet project. Into this file, merge the information from the `pom.xml` you find in *this* repository. Probably, it suffices to add the whole `<profiles>...</profiles>` section.

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
Whenever something got pushed to your OpenShift remote repository, a git hook named `post-receive` get executed on your remote machine. See for yourself in `~/git/jetty.git/hooks/` . Here is the gist of what's happening then.
* Your remote repository gets checked out on the same machine to the folder `$OPENSHIFT_REPO_DIR`
* Your repository's `.openshift/action_hooks/build` gets called. Ooops, that doesn't exist. So let's move on.
* Your repository's `.openshift/action_hooks/deploy` gets called. Ooops, that doesn't exist either. So let's move on.
* Some OpenShift-provided script called `start_app.sh` gets called. This script starts cartridges in the following order: first database cartridges, then additional cartridges, then your application cartridge (via `app_ctl.sh start`)

Up until now, all this behavior is provided by the OpenShift framework. Now, inside the `app_ctl.sh` our provided custom action hook named `start` gets called. So what does `start` do? Here is the gist
* `start` will *on-the-fly* download and execute the scripts `setup.sh`, `build.sh`, and `start.sh` of *this* repository, in that order
* `setup.sh`: This script will check if your $OPENSHIFT_DATA_DIR directory contains a copy of Jetty. If it doesn't, it will download some version of Jetty, and extract it. The script will delete two folders inside the extracted Jetty directory. These folders contain example Servlets and their configuration which we don't need. Also, the script writes a version file to the Jetty folder. Additionally, `setup.sh` will download a `maven.xml` file which is used for configure Maven later on.
* `build.sh`: This script changes to your $OPENSHIFT_REPO_DIR and build your project. It uses settings from the `maven.xml` just downloaded. This setting changes the location of your *local Maven artifact repository* to `$OPENSHIFT_DATA_DIR/maven`. The default local Maven artifact repository location wouldn't work, as the default location isn't writable on an OpenShift machine... but back to `build.sh`. It starts the Maven build with a further option `-Popenshift`. Remember when we modified the `pom.xml` of your project? This profile *openshift* will make sure your web application gets build to directory `deployments`, with a filename `ROOT.war`. [Jetty will deploy a file named ROOT.war to the context path "/"](http://wiki.eclipse.org/Jetty/Howto/Deploy_Web_Applications).  
* 