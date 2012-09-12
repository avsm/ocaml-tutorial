open Core.Std
module Command = Core_extended.Std.Command
module Afield = Command.Annotated_field

module Config = struct
  type t = { name: string;
             foo: float;
             bar: int;
           } with sexp, fields

  let  x = Fields.fold

  let fields =
    let open Afield in
    Fields.fold ~init:[]
      ~name:(required ~doc:"specify the name of a field")
      ~foo:(required ~doc:"which foo are you?")
      ~bar:(required ~doc:"which bar to flue?")
end
