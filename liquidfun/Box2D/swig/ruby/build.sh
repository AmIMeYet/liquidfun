swig -c++ -ruby -autorename liquidfun.swig
ruby extconf.rb
make
rdoc -E cxx=c -f html liquidfun_wrap.cxx