function polysides(d,r)    = let(d=is_undef(d)?2*r:d) max(round(2*d),3);
function polyradius(r,d)   = let(d=is_undef(d)?2*r:d) d/2/cos(180/polysides(d=d));
function polyr(r,d)        = polyradius(r,d);
function polydiameter(d,r) = let(d=is_undef(d)?2*r:d) d/cos(180/polysides(d=d));
function polyd(d,r)        = polydiameter(d,r);

include <BOSL/constants.scad>
use <BOSL/math.scad>
use <BOSL/shapes.scad>
module polycyl(
	l=undef, h=undef,
	r=undef,
	d=undef,
	chamfer=undef,
	chamfang=undef,
	fillet=undef,
	circum=true, realign=false, from_end=false,
	orient=ORIENT_Z, align=V_CENTER, center=undef
) {
  assert(!(is_undef(r) && is_undef(d)), "I need `r` or `d`.`");

  d=is_undef(d)?2*r:d;
  cyl(
    l=l, h=h,
    d=d,
    chamfer=chamfer,
    chamfang=chamfang,
    fillet=fillet,
    circum=circum, realign=realign, from_end=from_end,
    orient=orient, align=align, center=center,
    $fn=polysides(d=d)
  );
}
