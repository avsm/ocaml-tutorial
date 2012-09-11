open Cow
open Printf
open Slides

let rt = ">>"

let header =[ {
  styles=[Title];
  content= <:xml<
   <h1>Real World OCaml</h1>
   <br />
   Tutorial T3<br />
   Commercial Users of Function Programming (CUFP),<br />
   Copenhagen, Denmark, Sep 2012
  >>;
}]

let p2 = {
  styles=[Fill];
  content= <:xml<
<h3>Code</h3>
<section><pre>
<![CDATA[
open Lwt 
open OS

let main () =
  let heads =
    Time.sleep 1.0 $str:rt$
    return (Console.log "Heads");
  in
  let tails =
    Time.sleep 2.0 $str:rt$
    return (Console.log "Tails");
  in
  lwt () = heads <&> tails in
  Console.log "Finished";
  return ()
]]>
</pre></section>
   >>
}

let footer = [{
  styles=[];
  content= <:xml<
    <h1>The End
    <br /><small>now stand around the watercooler and discuss things</small>
    </h1>
  >>
}]
let articles = List.flatten [
  header;
  Intro.slides;
  Lwt_tutorial.slides;
  Lwt_exercises.slides;
  Miragep4.slides;
  footer;
]

let presentation = {
  topic="CUFP 2012 Tutorial";
  layout=Regular;
  articles;
}

let body =
  let slides = Slides.slides presentation in
  printf "%d slides\n%!" (List.length articles);
  Xml.to_string slides
