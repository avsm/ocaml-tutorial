all: 
	ocaml setup.ml -configure
	ocaml setup.ml -build -classic-display

.PHONY:clean
clean:
	ocamlbuild -clean
	rm -f setup.data setup.log
