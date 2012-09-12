open Core.Std
open Async.Std
open Protocol
module Command = Core_extended.Command

(* Defaults are set here, and can be overridden by command-line arguments. *)
let hostname = ref "127.0.0.1"
let port = ref 8080

let hostname_flag =
  Command.Flag.set_string "-hostname" hostname
    ~doc:" broker's hostname"

let port_flag =
  Command.Flag.set_int "-port" port
    ~doc:" broker's port"

(** [start_async f] runs the function f, shutting down when it's done, and also calls
    [Scheduler.go] to get the async event-loop started.  *)
let start_async f =
  whenever (f () >>= fun () -> return (shutdown 0));
  never_returns (Scheduler.go ())

let with_rpc_conn f =
  Tcp.with_connection ~host:!hostname ~port:!port (fun r w ->
    Rpc.Connection.create r w ~connection_state:()
    >>= function
      | Error exn -> raise exn
      | Ok conn -> f conn
  )

let shell cmd args =
  In_thread.run (fun () -> Core_extended.Shell.run_full cmd args)

let publish (topic,text) =
  with_rpc_conn (fun conn ->
    shell "whoami" []
    >>= fun username ->
    let from = Username.of_string (String.strip username) in
    Rpc.Rpc.dispatch_exn publish_rpc conn
      { Message.
        text; topic; from; time = Time.now () }
  )

let pub_cmd = Command.create_no_accum
  ~summary:"publish a single value"
  ~usage_arg:"<topic> <text>"
  ~flags:[hostname_flag;port_flag]
  ~final:(function
    | [topic;msg] ->
      (Topic.of_string topic,msg)
    | _ -> failwith "wrong number of arguments")
  (fun args -> start_async (fun () -> publish args))

let subscribe topic =
  with_rpc_conn (fun conn ->
    shell "clear" []
    >>= fun clear_string ->
    Rpc.Pipe_rpc.dispatch_exn subscribe_rpc conn topic
    >>= fun (pipe,_id) ->
    Pipe.iter pipe ~f:(fun msg ->
      printf "%s%s\n%!" clear_string msg.Message.text;
      return ()
    ))

let sub_cmd = Command.create_no_accum
  ~summary:"subscribe to a topic"
  ~usage_arg:"<topic>"
  ~flags:[hostname_flag; port_flag]
  ~final:(function
    | [topic] -> Topic.of_string topic
    | _ -> failwith "wrong number of arguments")
  (fun args -> start_async (fun () -> subscribe args))


let dump () =
  with_rpc_conn (fun conn ->
    Rpc.Rpc.dispatch_exn dump_rpc conn ()
    >>= fun dump ->
    printf "%s\n"
      (Dump.sexp_of_t dump |! Sexp.to_string_hum);
    return ()
  )

let dump_cmd = Command.create_no_accum
  ~summary:"Get a full dump of the broker's state"
  ~usage_arg:""
  ~flags:[hostname_flag; port_flag]
  ~final:(function
    | [] -> ()
    | _ -> failwith "wrong number of arguments")
  (fun args -> start_async dump)

let () =
  Exn.handle_uncaught ~exit:true (fun () ->
    Command.run ~version:"0.1" ~build_info:"N/A"
      (Command.group ~summary:"Utilities for interacting with message broker"
         [ "publish"  , pub_cmd
         ; "subscribe", sub_cmd
         ; "dump"     , dump_cmd
         ]))

