open Lwt (* provides >>= and join *)

let read_line () =
  Lwt_unix.sleep (Random.float 1.5) >|=
  fun () -> String.make (Random.int 20) 'a'

(* Functional version *)
let rec echo_server =
  function
  |0 -> return ()
  |num_lines ->
    lwt s = read_line () in
    print_endline s;
    echo_server (num_lines - 1)

(* Imperative version *)
let echo_server_2 num =
  for_lwt i = 1 to num do
     read_line () >|=
     print_endline
  done

let _ =
  Random.self_init ();
  Lwt_main.run (echo_server 10)
