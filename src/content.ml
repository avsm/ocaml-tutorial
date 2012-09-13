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

let footer = [{
  styles=[];
  content= <:xml<
    <h1>Le Fin
    <br /><small>now stand around the watercooler and discuss things</small>
    </h1>
  >>
}]
let articles = List.flatten [
  header;
  Intro.slides;
  Opam.slides;
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

