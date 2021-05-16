include <BOSL2/std.scad>

function polysides(d,r)    = let(dd=is_undef(d)?2*r:d) max(round(2*dd),3);
function polyfactor(r,d)   = let(dd=is_undef(d)?2*r:d) cos(180/polysides(d=dd));
function polyradius(r,d)   = let(dd=is_undef(d)?2*r:d) dd/2/polyfactor(d=dd);
function polyr(r,d)        = polyradius(r,d);
function polydiameter(d,r) = let(dd=is_undef(d)?2*r:d) dd/polyfactor(d=dd);
function polyd(d,r)        = polydiameter(d,r);

function only_defined(v)=[for(i=v) if(!is_undef(i)) i];
// function first_defined(v)=only_defined(v)[0];

module polycyl(
		h, r, center,
		l, r1, r2,
		d, d1, d2,
		chamfer, chamfer1, chamfer2,
		chamfang, chamfang1, chamfang2,
		rounding, rounding1, rounding2,
		circum=false, realign=false, from_end=false,
		anchor, spin=0, orient=UP
) {
	l = first_defined([l, h, 1]);

	rrr1 = get_radius(r1=r1, r=r, d1=d1, d=d, dflt=1);
	rrr2 = get_radius(r1=r2, r=r, d1=d2, d=d, dflt=1);
	sc = circum? 1/cos(180/sides) : 1;

	rr1 = rrr1*sc;
	rr2 = rrr2*sc;

	echo(l=l, rrr1=rrr1, rrr2=rrr2, sides=sides, sc=sc, rr1=rr1, rr2=rr2);

	sides = polysides(
			r=2*min(rr1,rr2)
		);

	anchor = get_anchor(anchor,center,BOT,CENTER);
	cyl(
		center=center,
		l=l, r1=rr1, r2=rr2,
		chamfer=chamfer, chamfer1=chamfer1, chamfer2=chamfer2,
		chamfang=chamfang, chamfang1=chamfang1, chamfang2=chamfang2,
		rounding=rounding, rounding1=rounding1, rounding2=rounding2,
		circum=circum, realign=realign, from_end=from_end,
		anchor=anchor, spin=spin, orient=orient,
		$fn=sides
	) children();
}

module polytube(
	h, wall=undef,
	r=undef, r1=undef, r2=undef,
	d=undef, d1=undef, d2=undef,
	or=undef, or1=undef, or2=undef,
	od=undef, od1=undef, od2=undef,
	ir=undef, id=undef, ir1=undef,
	ir2=undef, id1=undef, id2=undef,
	anchor, spin=0, orient=UP,
	center, realign=false, l,
  force=false
) {
	h = first_defined([h,l,1]);
	r1 = first_defined([or1, od1/2, r1, d1/2, or, od/2, r, d/2, ir1+wall, id1/2+wall, ir+wall, id/2+wall]);
	r2 = first_defined([or2, od2/2, r2, d2/2, or, od/2, r, d/2, ir2+wall, id2/2+wall, ir+wall, id/2+wall]);
	ir1 = first_defined([ir1, id1/2, ir, id/2, r1-wall, d1/2-wall, r-wall, d/2-wall]);
	ir2 = first_defined([ir2, id2/2, ir, id/2, r2-wall, d2/2-wall, r-wall, d/2-wall]);
	assert(ir1 <= r1, "Inner radius is larger than outer radius.");
	assert(ir2 <= r2, "Inner radius is larger than outer radius.");
  if(!force) {
    let(poly_r1=ir1/polyfactor(min(ir1,ir2)))
      assert(poly_r1>(r1+0.6),
             str("That would leave you with very little support (minimum wall from r1: ",r1-poly_r1,
                 " is less than 0.6). `force=true` to override."));
    let(poly_r2=ir2/polyfactor(min(ir1,ir2)))
      assert(poly_r2>(r2+0.6),
             str("That would leave you with very little support (minimum wall from r2: ",r2-poly_r2,
                 " is less than 0.6). `force=true` to override."));
  }
	sides = segs(max(r1,r2));
	anchor = get_anchor(anchor, center, BOT, BOT);
	attachable(anchor,spin,orient, r1=r1, r2=r2, l=h) {
		zrot(realign? 180/sides : 0) {
			difference() {
				cyl(h=h, r1=r1, r2=r2, $fn=sides) children();
				polycyl(h=h+0.01, r1=ir1, r2=ir2, circum=true);
			}
		}
		children();
	}
}

