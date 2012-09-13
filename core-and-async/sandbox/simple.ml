open Core.Std
open Async.Std

let rec run_rec i =
  printf "<%d>" i;
  Clock.after (sec 0.3)
  >>= fun () -> run_rec (i+1)

let run_every () =
  let i = ref 0 in
  every (sec 0.3) (fun () -> printf "[%d]" !i; incr i)

let () =
  whenever (run_rec 0);
  run_every ();
  never_returns (Scheduler.go ())

