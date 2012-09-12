open Lwt
open Cow
open Printf
open Slides

let rt = ">>" (* required to embed it in html p4 as cant put that token directly there *)
let dl = "$"

let threads num =
  let fname = "unix_threads" ^ (string_of_int num) ^ ".svg" in
{
  styles=[Fill];
  content= <:html<
    <section>
    <object data=$str:fname$ type="image/svg+xml">&nbsp;</object>
    </section>
  >>
}

let slides = [
{ styles=[];
  content= <:html<
    <h1>Lightweight Threading
    <br />
     <small>using the Lwt library</small>
    </h1>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Lightweight Threads</h3>
    <ul>
     <li>Lwt provides threads that are <b>event-driven</b> with no preemption.</li>
     <li> An Lwt-driven program 
         executes all threads sequentially until none can make progress, and then sleeps until woken up by an I/O event or timeout.</li>
     <li><tt>Lwt</tt> abstracts event callbacks to maintain the illusion of straight-line control flow in code you write.</li>
    </ul>
    <p>Let's look at some examples.
    They are all in<br /> <a href="https://github.com/avsm/ocaml-tutorial/tree/master/">ocaml-tutorial/examples/lwt</a>, and you build them by:</p>
    <section><pre class="noprettyprint">
$str:dl$ ocaml setup.ml -configure
$str:dl$ ocaml setup.ml -build
$str:dl$ ./sleep.byte</pre></section> 
>>
}; 
{ 
  styles=[];
  content= <:html<
    <h3>The Lwt monad</h3>
<section><pre>
val return : 'a -> 'a Lwt.t
</pre></section> 
  <p><tt><a href="http://ocsigen.org/lwt/api/Lwt#VALreturn">Lwt.return</a> v</tt> builds a thread that returns with value <tt>v</tt>.</p>
<section><pre>
val bind : 'a Lwt.t -> ('a -> 'b Lwt.t) -> 'b Lwt.t
</pre></section> 
<p><tt><a href="http://ocsigen.org/lwt/api/Lwt#VALbind">Lwt.bind</a> t f</tt> creates a thread which waits for <tt>t</tt> to terminate, then pass the result to <tt>f</tt>. If <tt>t</tt> is a sleeping thread, then <tt>bind t f</tt> will sleep too, until <tt>t</tt> terminates.</p>
<section><pre>
val join : unit Lwt.t list -> unit Lwt.t
</pre></section> 
<p><tt><a href="http://ocsigen.org/lwt/api/Lwt#VALjoin">Lwt.join</a></tt> takes a list of threads and waits for them all to terminate.</p>
  >>
};
{ 
  styles=[];
  content= <:html<
    <h3>A Simple Sleeping Example</h3>
<pre>
  Lwt.bind
    (Lwt_unix.sleep 1.0)
    (fun () ->
       Lwt.bind
         (Lwt_unix.sleep 2.0)
         (fun () ->
            print_endline "Wake up sleepy!\n";
            Lwt.return ()
         )
    )</pre>
<p>More natural ML style, via syntax extension:</p>
<pre>
  lwt () = Lwt_unix.sleep 1.0 in
  lwt () = Lwt_unix.sleep 2.0 in
  print_endline "Wake up sleepy!\n";
  Lwt.return ()</pre>
  >>
};
{
  styles=[];
  content= <:html<
   <h3>Lwt syntax extension</h3>
<p><tt>lwt/sleep.ml</tt></p>
<pre>
  lwt () = Lwt_unix.sleep 1.0 in
  lwt () = Lwt_unix.sleep 2.0 in
  print_endline "Wake up sleepy!\n";
  Lwt.return ()</pre>
<p>After syntax transform:</p>
<pre>
  let __pa_lwt_0 = Lwt_unix.sleep 1.0 in
  Lwt.bind __pa_lwt_0 (fun () ->
    let __pa_lwt_0 = Lwt_unix.sleep 2.0 in
    Lwt.bind __pa_lwt_0 (fun () -> 
      (print_endline "Wake up sleepy!\n";
       Lwt.return ()
      )
    )
  )</pre>
>>
};
{ 
  styles=[];
  content= <:html<
    <h3>Behind the Scenes</h3>
    <p>Many Lwt core modules are portable, such as <tt>Lwt</tt>, <tt>Lwt_stream</tt> and <tt>Lwt_mvar</tt>. The thread scheduler is itself written in OCaml, and is operating system specific.  On Unix, this is <tt>Lwt_unix</tt> for most POSIX calls, and <tt>Lwt_main</tt> to execute the main loop.</p>
    <p>Lwt uses <tt>libev</tt> under the hood, which waits for I/O events using the best available interface (select, kqueue or epoll).
    Timeouts are stored in an efficient priority queue, and so millions of threads can be sleeping simultaneously, limited only by heap memory.</p>
    <pre>
let t,u = Lwt.task () in // t sleeps forever
Lwt.wakeup u "foo";      // and u can wake it up  
t                        // value carried by t is "foo" </pre>
<p>The outside world wakes up sleeping threads via the <tt><a href="http://ocsigen.org/lwt/api/Lwt#VALwakeup">Lwt.wakeup</a></tt> mechanism:</p>
<ul>
</ul>
  >>
};
threads 1;
threads 2;
threads 3;
threads 4;
threads 5;
threads 6;
]
