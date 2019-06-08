require 'mkmf'
# find_library('Box2D', '../..')

# # enum all source files
# $srcs = ["liquidfun_wrap.cxx"] #"lib/file.c"

# add include path to the internal folder
# $(srcdir) is a root folder, where "extconf.rb" is stored
$INCFLAGS << " -I$(srcdir)/../.."

# # add folder, where compiler can search source files
# $VPATH << "$(srcdir)/../../Box2D"

$DLDFLAGS << " -L$(srcdir)/../../Box2D/Debug/ -lliquidfun "

# $CXXFLAGS << " -L$(srcdir)/../../Box2D/Release/libliquidfun -lGR -lm -Wl,-rpath,$(srcdir)/../../Box2D/Release/libliquidfun "
# $CXXFLAGS += " -I/usr/local/gr/include -L/usr/local/gr/lib -lGR -lm -Wl,-rpath,/usr/local/gr/lib " ??

$CXXFLAGS += " -g "

create_makefile('liquidfun')
