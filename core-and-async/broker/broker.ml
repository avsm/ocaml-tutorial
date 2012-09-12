open Core.Std
open Async.Std
open Protocol

let publish_impl dir msg =
  Directory.publish dir msg;
  return ()

let subscribe_impl dir topic ~aborted =
  return (
    match Directory.subscribe dir topic with
    | None -> Error ()
    | Some pipe ->
      whenever (aborted >>| fun () -> Pipe.close_read pipe);
      Ok pipe
  )
;;

let dump_impl dir () =
  return (Directory.dump dir)

let implementations =
  [ Rpc.Rpc.     implement publish_rpc   publish_impl
  ; Rpc.Pipe_rpc.implement subscribe_rpc subscribe_impl
  ; Rpc.Rpc.     implement dump_rpc      dump_impl
  ]

let start_server () =
  let server =
    match
      Rpc.Server.create
        ~implementations
        ~on_unknown_rpc:`Ignore
    with
    | Ok x -> x
    | Error (`Duplicate_implementations _) -> assert false
  in
  let directory = Directory.create () in
  Tcp.serve ~port:8080 ~on_handler_error:`Ignore
    (fun _addr r w ->
      Rpc.Connection.server_with_close r w
        ~connection_state:directory
        ~on_handshake_error:`Ignore
        ~server
    )

let () =
  whenever (start_server ());
  never_returns (Scheduler.go ())
