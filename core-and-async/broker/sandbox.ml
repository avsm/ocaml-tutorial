open Core.Std

type v = | Gnu | Snu with variants

type z = int list with sexp, bin_io

type u = { foo: z;
           bar: float;
         }
with sexp, bin_io, fields

let sum u = float (List.hd_exn (foo  u)) +. bar u

type t = int * string with sexp

let x = 3
let x = x + 1
let () =
  printf "%d\n" x



