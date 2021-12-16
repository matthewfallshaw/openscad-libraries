include <BOSL2/std.scad>;
include <BOSL2/fnliterals.scad>;
use <polyholes.scad>;

echo("## Stdlib ##");

$slop=0.3;

// # 3D printing: Speed profile
// line widths
c_lw    = 0.45;  // default
c_lw1   = 0.45;  // first layer
c_lwp   = 0.5;   // perimeters
c_lwep  = 0.45;  // external perimeters
c_lwi   = 0.45;  // infill
c_lwsi  = 0.6;   // solid infill
c_lwtsi = 0.4;   // top solid infill
c_lws   = 0.35;  // supports
// layer height
c_lh    = 0.2;   // layer height
// other constants
BIGNUM  = 1000;  // a big number
c_eps   = 0.01;  // a small number
rb2     = repeat(BIGNUM,2);
rb3     = repeat(BIGNUM,3);

echo("-- Constants:"
    ,$slop=$slop
    ,c_lw=c_lw    ,c_lw1=c_lw1    ,c_lwp=c_lwp    ,c_lwep=c_lwep
    ,c_lwi=c_lwi  ,c_lwsi=c_lwsi  ,c_lwtsi=c_lwtsi,c_lws=c_lws  ,c_lh=c_lh
    ,BIGNUM=BIGNUM
    ,rb2=rb2
    ,rb3=rb3
);

// convenient constants
s_command=hashmap(
  items=[
    ["large" , hashmap( items=[
                          ["length_total" ,93]
                         ,["length_sticky",68]
                         ,["length"       ,80]
                         ,["width"        ,75/4]
                         ]
                      )
    ]
   ,["medium", hashmap( items=[
                          ["length_total" ,70]
                         ,["length_sticky",46]
                         ,["length"       ,55]
                         ,["width"        ,63/4]
                         ]
                      )
    ]
   ,["small" , hashmap( items=[
                         ["length_total" ,46]
                        ,["length_sticky",22]
                        ,["length"       ,31]
                        ,["width"        ,63/4]
                        ]
                      )
    ]
  ]
);

echo("-- Hashmaps:");
echo(hash_dump(s_command, "s_command"));

function quant_wall(width,lwp=c_lwp,lwep=c_lwep)=
  (width<(2*lwep+lwp)?quant(wall,lwep):quant(width-2*lwep,lwp)+2*lwep)+0.02;
function r2(n)=is_type(n, "list")
    ? select(n, 0, 1)
    : repeat(n,2);
function r3(n)=is_type(n, "list")
    ? select(n, 0, 2)
    : repeat(n,3);
function join(l, sep) = reduce(function(x,y) str(x,y), [for(i=idx(l)) str(i==0 ? l[i] : str(sep, l[i]))], "");
function outline_path(p, width) =
  // close_path(
    flatten(
      map(
        function(x) force_path(x)
      , [ reverse(offset(p, delta=-width/2)), offset(p, r=width/2) ]
      )
    // )
  );

echo("-- Functions:"
    ,"quant_wall(width,lwp=c_lwp,lwep=c_lwep)"
    ,"r2(n)  // [n,n]"
    ,"r3(n)  // [n,n,n]"
    ,"join(l, sep) => str  // items of l joined by sep"
    ,"outline_path(p, width)   // single line path offset on each side by width/2"
    );

echo("-- -- -- --");


function struct_dump(struct,struct_name,indent=0)=
  str(LF,_indent(indent),struct_name
     ,str_join([ for(i=struct)
                 let(k=i[0],v=i[1])
                 ( is_struct(v)
                     ? struct_dump(v,k,indent+1)
                     : str(LF,_indent(indent+1),str(k,": ",v))
                 )
               ]
              )
     );

LF=chr(10);
function _indent(n)=str_join(repeat("  ",n),"");

function hash_dump(hm, hash_name, indent=0)=
  str(LF,_indent(indent), hash_name
     ,str_join([ for(i=hm())
                 let(k=i[0],v=i[1])
                 ( is_function(v)
                     ? hash_dump(v,k,indent+1)
                     : str(LF,_indent(indent+1),str(k,": ",v))
                 )
               ]
              )
     );
