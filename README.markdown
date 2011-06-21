rb\_upload
==========

A boringly named upload tool written in Ruby.

Installation
------------

Run the following command:

    sudo ln -s ./rb_upload.rb /usr/bin/rbup

to add the executable to your PATH as `rbup`.

In Cygwin, add the following to your .bashrc:

    alias rbup='/path/to/rb_upload/rb_upload.rb'

Usage
-----

To use `rb_upload`, make a copy of the `upload_settings.yml` file and place it
in the directory you wish to upload. Set `local_directory` to `"."` if you want
to upload the files directly from this directory.

Run `rbup` in the directory to upload all files to the specified remote
directory.

For other options, run

    rbup -h

Netrc
-----

You'll need a .netrc file with the credentials for every site you use. Make
sure its permissions are set with `chmod` to `600`, or it may not work.

Known issues
------------

The major issue is that filesize comparison will only work with ascii files if
the line endings on the server and dev machine are setup the same - if you're
uploading to a Linux box, you need to make sure your local files use `\n`
endings or it'll judge the local and remote files to be different.
