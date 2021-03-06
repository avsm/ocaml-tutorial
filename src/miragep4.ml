open Lwt
open Printf
open Cow
open Slides

 (* required to embed it in html p4 as cant put that token directly there *)
let html = "<:html<"
let html = <:html<$str:html$>>

let css = "<:css<"
let css = <:html<$str:css$>>

let cl = ">>"
let cl = <:html<$str:cl$>>

let dl = "$"
let dl = <:html<$str:dl$>>

let slides = [
{ styles=[];
  content= <:html<
    <h1>Structuring your Code
    <br />
     <small>using OASIS and OPAM</small>
    </h1>
  >>
};
{ styles=[];
  content= <:html<
    <h3>OPAM basics</h3>
    <p>You can add multiple package repositories:</p>
<pre class="noprettyprint">
$dl$ opam remote -add dev git://github.com/mirage/opam-repo-dev
$dl$ opam remote -add core-pre git://github.com/avsm/opam-core-pre0
</pre>
     <p>You can also host local repositories on your laptop:</p>
<pre class="noprettyprint">
$dl$ git clone git://github.com/mirage/opam-repo-dev
$dl$ cd opam-repo-dev &amp;&amp; opam-mk-repo
$dl$ opam remote -add local opam-repo-dev
</pre>
     <p>OPAM supports <i>optional</i> dependencies, so sometimes installing a package will cause
packages to recompile.</p>
<pre class="noprettyprint">
$dl$ opam update
$dl$ opam upgrade
</pre>
  >>
};
{ styles=[];
  content= <:html<
    <h3>Useful OPAM commands</h3>
    <p>You can have multiple compilers installed at the same time:</p>
<pre class="noprettyprint">
$dl$ opam switch -list
$dl$ opam switch 4.00.0
$dl$ opam install async ssl lwt
$dl$ eval `opam config -env`
</pre>
    <p>The last command imports the correct environment variables for your shell.  It
is safe to run this from your <tt>.profile</tt> to ensure they are always set.</p>
    <p>OPAM is still in beta, so something goes horribly wrong, please file a <a href="http://github.com/OCamlPro/opam">bug report</a>.  You can delete <tt>~/.opam</tt> to remove all state and start from a clean slate.</p>
>>
};
{ styles=[];
  content= <:html<
    <h3>OASIS basics</h3>
    <ul>
      <li>Create an <tt>_oasis</tt> file that describes your project.</li>
      <li>OASIS generates a build system using the <tt>ocamlbuild</tt> tool.  It is easiest to copy an existing <tt>_oasis</tt> file and modify it (see <tt>examples/lwt/_oasis</tt>).</li>
      <li><tt>ocamlbuild</tt> is driven by a <tt>myocamlbuid.ml</tt> <a href="http://brion.inria.fr/gallium/index.php/Making_plugins">plugin</a> generated by OASIS.  All generated files are in <tt>_build</tt>.</li>
      <li>The <tt>_tags</tt> file contains <a href="http://brion.inria.fr/gallium/index.php/Tags">directives</a> for files, such as debug or profiling flags.</li>
    </ul>
>>
};
{ styles=[];
  content= <:html<
   <h3>OASIS Usage</h3>
<pre class="noprettyprint">
$dl$ oasis setup
$dl$ ocaml setup.ml -configure
$dl$ ocaml setup.ml -build
$dl$ ocaml setup.ml -install
</pre>
    <i>Important:</i> OASIS does not fully support syntax extensions yet, so you must manually add them to the <tt>_tags</tt> files
  >>
};
{ styles=[];
  content= <:html<
    <h1>Syntax Extensions
    <br />
     <small>the zen of camlp4</small>
    </h1>
  >>
};
{
  styles=[];
  content= <:html<
    <h3>Why Syntax Extensions?</h3>
    <ul>
     <li>Very convenient way to perform code-generation.</li>
     <li>OCaml has a comprehensive grammar extension mechanism.</li>
     <li>Core features many I/O backends (including sexpr, binio), and other third-party extensions include Lwt, monads and logging.</li>
    </ul>
  >>
};
{
  styles  =[];
  content = <:html<
    <h3>Web Syntax extensions</h3>
    <ul>
      <li>Web expressions (e.g. HTML or CSS) can written natively using <tt>cow</tt>:.
      <pre>let x = $html$&#60;h1>Hello&#60;/h1>World!$cl$</pre></li>

       <li>This expands to (<tt>make %.pp.ml</tt>):
       <pre>
let x = List.flatten [
  [ `El ((("", "h1"), []), [ `Data "Hello" ]) ];
  [ `Data "World!" ]
]</pre></li>
      
      <li>HTML and XML quotations are compiled to <tt>xmlm</tt> expressions by the pre-processor.</li>
    </ul> >>
};
{
  styles = [];
  content = <:html<
    <h3>Web Syntax extensions (ii)</h3>
    <ul>
      <li>One can use template-like (anti-quotations) to parameterize quotations:
      <pre>let x title = $html$&#60;h1>$dl$title$dl$&#60;/h1>content$cl$</pre></li>

      <li>This expands to:
      <pre>
let x title = List.flatten
  [ [ `El ((("", "h1"), []), title) ];
    [ `Data "content" ] ]</pre></li>
      
      <li>Typed templates:
      <pre>
let f (i : int) = $html$This is an int : $dl$int:i$dl$!$cl$
let f (s : string) = $html$This is a string : $dl$string:s$dl$!$cl$</pre></li>
   </ul>
  >>
};
{
  styles  = [];
  content = <:html<
    <h3>Web Syntax extensions</h3>
    <ul>
    <li>CSS quotations (with nested declarations):
    <pre>let y = $css$ h1 {background-color: blue; a { color: red; } } } $cl$</pre></li>

    <li>This expands to:
<pre>
let y = Cow.Css.unroll (
  Cow.Css.Props [
    Cow.Css.Decl (
      [[ Cow.Css.Str "h1" ]],
      ([ Cow.Css.Prop ("background-color", [[ Cow.Css.Str "blue" ]]) ] @
       [ Cow.Css.Decl (
         [[ Cow.Css.Str "a" ]],
         [ Cow.Css.Prop ("color", [ [ Cow.Css.Str "red" ]]) ]) ]))
  ])</pre></li></ul>
>>
};
(*
{
  styles  = [];
  content = <:html<
    <h3>Web Syntax extensions</h3>
    <ul>
    <li></li>
    <ul>
   >>
}*)
]

