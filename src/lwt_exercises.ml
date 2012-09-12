open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
let dl = "$"
let slides = [
{ styles=[];
  content= <:html<
    <h1>Lwt Exercises
    <br />
     <small>cool cooperative concurrency</small>
    </h1>
  >>
};
{ 
  styles=[];
  content= <:html<
    <h3>Heads or Tails?</h3>
    <p>Write a program that spins off two threads, each of which sleeps for some amount of time,
      say 1 and 2 seconds respectively, and then one prints "Heads",
      and the other "Tails".</p>
    <p>After both have finished, print "Finished" and exits.</p>
<pre class="noprettyprint">
$str:dl$ cd ocaml-tutorial/examples/lwt
$str:dl$ vim mysleep.ml
$str:dl$ make
# answer is in sleep.ml
</pre>
<ul>
<li><tt>Lwt_unix.sleep tm</tt> will sleep for <tt>tm</tt> seconds.</li>
<li><tt>print_endline</tt> prints a string to console.</li>
<li><a href="http://ocsigen.org/lwt/api/Lwt#VALjoin"><tt>Lwt.join</tt></a> waits for multiple threads to finish.</li>
</ul>
  >>
};
{ 
  styles=[];
  content= <:html<
    <h3>Echo Server</h3>
  <p>Write an echo server that reads from a dummy input generator and
  writes each input read to the console.
  The server should stop listening after 10 inputs are received.</p>
<pre class="noprettyprint">
$str:dl$ cd ocaml-tutorial/examples/lwt
$str:dl$ vim myecho1.ml
$str:dl$ make myecho1
# answer is in echo1.ml
</pre>
<p>You can use this function as a traffic generator:</p>
<pre>
let read_line () =
  Lwt_unix.sleep (Random.float 1.5) $str:rt$
  Lwt.return (String.make (Random.int 20) 'a')</pre>
  >>
}
]
