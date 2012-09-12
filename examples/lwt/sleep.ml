let main () =
  lwt () = Lwt_unix.sleep 1.0 in
  lwt () = Lwt_unix.sleep 2.0 in
  print_endline "Wake up sleep.ml!\n";
  Lwt.return ()
