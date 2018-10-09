# NethServer Enterprise groups composition

This is the repository of the YUM groups composition sources and relative localization
files.

## Changes workflow

1. Edit `nethserver-enterprise-groups.xml.in`

2. If the modification involves an XML node that can be translated see Localization below

3. Commit changes and open a pull request on GitHub

When the pull request is merged to `master` the automated build on Travis-CI.com
pushes the results to `packages.nethesis.it`. Note that:

* The changes are effective the next time the `nethesis-updates` repository
  metadata has been generated (i.e. an RPM was uploaded or `repobuild` command ran)

* The changes are published the next time rsync-pull-packages runs on `c6`

## Localization

The `_name` and `_description` nodes are ready for I18N. To translate them run the following commands

    make
    poedit po/*.po

Then commit the local changes to `po/comps.pot` and `po/*.po`. Proceed with the main workflow.

There are many alternatives to `poedit`, search the Internet for them.