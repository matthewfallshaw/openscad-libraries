include <BOSL2/std.scad>;
include <BOSL2/structs.scad>;
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
BIGNUM  = 1000;  // a big number

echo("-- Constants:"
    ,$slop=$slop
    ,c_lw=c_lw    ,c_lw1=c_lw1    ,c_lwp=c_lwp    ,c_lwep=c_lwep
    ,c_lwi=c_lwi  ,c_lwsi=c_lwsi  ,c_lwtsi=c_lwtsi,c_lws=c_lws  ,c_lh=c_lh
    ,BIGNUM=BIGNUM
);

// convenient constants
s_command=struct_set([]
                    ,["large" ,struct_set([]
                                         ,["length_total" ,93
                                          ,"length_sticky",68
                                          ,"length"       ,80
                                          ,"width"        ,75/4
                                          ]
                                         )
                     ,"medium",struct_set([]
                                         ,["length_total" ,70
                                          ,"length_sticky",46
                                          ,"length"       ,55
                                          ,"width"        ,63/4
                                          ]
                                         )
                     ,"small" ,struct_set([]
                                         ,["length_total" ,46
                                          ,"length_sticky",22
                                          ,"length"       ,31
                                          ,"width"        ,63/4
                                          ]
                                         )
                     ]);

echo(str("-- Structs:"
        ,struct_dump(s_command,"s_command")
        )
    );

function quant_wall(width,lwp=c_lwp,lwep=c_lwep)=
  (width<(2*lwep+lwp)?quant(wall,lwep):quant(width-2*lwep,lwp)+2*lwep)+0.02;
function r2(n)=repeat(n,2);
function r3(n)=repeat(n,3);
function rb2()=repeat(BIGNUM,2);
function rb3()=repeat(BIGNUM,3);

echo("-- Functions:"
    ,"quant_wall(width,lwp=c_lwp,lwep=c_lwep)"
    ,"r2(n)  // [n,n]"
    ,"r3(n)  // [n,n,n]"
    ,"rb2()  // [BIGNUM,BIGNUM]"
    ,"rb3()  // [BIGNUM,BIGNUM,BIGNUM]"
    );


// function struct_dump(struct,indent=1)=str(LF,"  ",str_join(c_command,str(LF,"  ")));
function struct_dump(struct,struct_name,indent=0)=
  str(LF,_ind(indent),struct_name
     ,str_join([ for(i=struct)
                 let(k=i[0],v=i[1])
                 ( is_struct(v)
                     ? struct_dump(v,k,indent+1)
                     : str(LF,_ind(indent+1),str(k,": ",v))
                 )
               ]
              )
     );
  // str(LF,_ind(indent),str_join(struct,str(LF,_ind(indent))));

LF=chr(10);
function _ind(n)=str_join(repeat("  ",n),"");
