ifeq ($(MIRAGE_OS),xen)
FLAGS=--enable-xen --disable-unix
else
FLAGS=--enable-unix --disable-xen
endif

all: 
	ocaml setup.ml -configure $(FLAGS)
	ocaml setup.ml -build
	./_build/src/main.native

.PHONY:clean
clean:
	ocamlbuild -clean
