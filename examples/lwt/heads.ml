open Lwt

let main () =
  let heads =
    Lwt_unix.sleep 1.0 >>
    (* The (>>) operator is an "anonymous bind". All these are
       the same function:
       t1 >> t2
       lwt () = t1 in t2
       t1 >>= fun () -> t2
     *) 
    return (print_endline "Heads");
  in
  let tails =
    Lwt_unix.sleep 2.0 >>
    return (print_endline "Tails");
  in
  (* The <&> operator is an alias for Lwt.join *)
  lwt () = heads <&> tails in
  return (print_endline "Finished")

let _ = Lwt_main.run (main ())
