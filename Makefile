CXX := g++
PROG := flapmodel
CSRC := $(PROG).cxx parse.cxx
PREFIX := /usr
INSTPREFIX := /usr/local
INC := -I$(PREFIX)/local/include/vtk
LIB := -lm -lvtkCommon -lvtkIO -lvtkWidgets -lvtkRendering -lvtkFiltering -lvtkGraphics -lvtkImaging -L$(PREFIX)/lib/vtk
#LIB += -lefence
CXXFLAGS := -Wall -O2 -Wno-deprecated
#CXXFLAGS := -Wall -g -Wno-deprecated
JUNK := *~ *.bak *.o core *.vsp *.vtk *.ply *.stl *.png
SRCDIR := $(shell basename `pwd`)

.PHONY: all clean depend distclean edit test png install

all: $(PROG)

ref: ref.cxx
	$(CXX) -o $@ $(INC) $(CXXFLAGS) $(LIB) $<

$(PROG): $(CSRC:.cxx=.o)
	$(CXX) -o $@ $(CSRC:.cxx=.o) $(LIB)

%.o: %.cxx
	$(CXX) -c $(INC) $(CXXFLAGS) $<

clean:
	-test -z "$(JUNK)" || rm -f $(JUNK)

distclean:
	-test -z "$(JUNK) $(PROG)" || rm -f $(JUNK) $(PROG)

edit:
	xemacs Makefile *.c *.cxx *.h *.txt & 

test: $(PROG)
	./$(PROG) ; srfmsh flapmodel_test.vsp ; showmodel.sh flapmodel_test.vtk &

png: $(PROG)
	./$(PROG) ; vsptoim flapmodel_test.vsp

install: $(PROG)
	install $(PROG) $(INSTPREFIX)/bin

archive: distclean
	tar cvjf /tmp/$(SRCDIR).tar.bz2 ../$(SRCDIR)/*

depend:
	makedepend -I$(INC) -Y *.c


# DO NOT DELETE THIS LINE -- make depend depends on it.
