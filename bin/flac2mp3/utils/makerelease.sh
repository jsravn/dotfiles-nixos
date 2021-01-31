#!/bin/bash

# utility to create a release

# Steps:
#
# Pre-release work:
# ================
#  - Update change log
#  - tag release in subversion
#    svn copy trunk tags/RELEASE-x.y.z
#

export VER="0.3.0rc3"

# Building a release
# ==================
#  - export release tag into temp dir
    svn export \
        http://projects.robinbowes.com/svn/flac2mp3/tags/RELEASE-${VER} \
        flac2mp3-${VER} &&
#  - remove some dirs from the export so they aren't packaged
        rm -rf flac2mp3-${VER}/patches flac2mp3-${VER}/utils &&
#  - create tarball and gzip
        tar cvzf flac2mp3-${VER}.tar.gz flac2mp3-${VER} &&
#  - create zip file (for windows users)
        zip -r9 flac2mp3-${VER}.zip flac2mp3-${VER} &&
#  - copy to download directory
	scp \
		flac2mp3-${VER}.tar.gz \
		flac2mp3-${VER}.zip \
		root@projects.robinbowes.com:/var/www/projects/htdocs/download/flac2mp3
