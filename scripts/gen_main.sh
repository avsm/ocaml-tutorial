#!/bin/sh -e

mir-crunch -name "static" static > src/filesystem_static.ml 
echo open Filesystem_static > src/main.ml
echo open Server >> src/main.ml
echo "let _ = OS.Main.run (main ())" >> src/main.ml
