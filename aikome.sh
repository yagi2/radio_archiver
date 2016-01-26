#!/bin/bash
PATH=$PATH:$HOME/local/bin:$HOME/local/lib/ruby/gem/bin:/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:$HOME/bin
RUBYLIB=$HOME/local/lib/ruby/site_ruby/2.0.0:$HOME/local/lib/ruby/2.0.0
GEM_HOME=$HOME/local/lib/ruby/gems

export RUBYLIB
export GEM_HOME
export PATH

/home/yagi2/local/bin/ruby -v

/home/yagi2/local/bin/ruby /home/yagi2/Dropbox/agqr/aikome.rb