packaging
=========

Script for generating Newscoop packages.

##Usage
```
------------------------------------------------------------
Sourcefabric Newscoop Packaging script
Usage
------------------------------------------------------------
   -h shows this usage
   -p PACKAGE_NAME
      The package name
      Defaults to newscoop-package
   -v VERSION
      The package version
      Defaults to the current date (2013.05.27)
   -f FORMAT
      The output format, can be either ZIP or TAR
      Defaults to TAR
   -d TARGET_DIR
      The Git clone TARGET_DIR
      Defaults to newscoop_packaging
   -i vendor include
      includes Composer and the Vendors
------------------------------------------------------------
Git checkout method
Only one of the following can be used.
------------------------------------------------------------
   -c GIT_COMMIT
      Defines which GIT COMMIT HASH should be packaged
      GIT COMMIT HASH needs to be a minimum of 7 characters
   -b GIT_BRANCH
      Defines which GIT BRANCH should be packaged
   -t GIT_TAG
      Defines which GIT TAG should be packaged

If none is specified it defaults to BRANCH [master]

Advanced settings:

   -r REPO
      The Repo to pull from
      Defaults to sourcefabric/Newscoop.git
   -u URL
      The base URL to pull from
      Defaults to https://github.com/
```
