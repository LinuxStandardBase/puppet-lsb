# nodes.pp
# Import node definitions from individual files

# This file has to be touched (mtime updated) when the files in this wildcard
# change. There should be a post-update hook to do this in the puppetmaster
# hgrc!
import 'nodes/*'
