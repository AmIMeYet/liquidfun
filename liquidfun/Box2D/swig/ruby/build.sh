swig4.0.1 -c++ -ruby -autorename liquidfun.swig
ruby extconf.rb
make V=1
rdoc -E cxx=c -f html liquidfun_wrap.cxx
