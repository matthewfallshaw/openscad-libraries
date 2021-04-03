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
	l=undef, h=undef,
	r=undef, r1=undef, r2=undef,
	d=undef, d1=undef, d2=undef,
	chamfer=undef, chamfer1=undef, chamfer2=undef,
	chamfang=undef, chamfang1=undef, chamfang2=undef,
	rounding=undef, rounding1=undef, rounding2=undef,
	circum=true, realign=false, from_end=false,
	center, anchor, spin=0, orient=UP
) {
	r1 = get_radius(r1=r1, r=r, d1=d1, d=d, dflt=1);
	r2 = get_radius(r1=r2, r=r, d1=d2, d=d, dflt=1);
	l = first_defined([l, h, 1]);
	sides = polysides(2*min(r1,r2));
	sc = circum? 1/cos(180/sides) : 1;
	phi = atan2(l, r2-r1);
	anchor = get_anchor(anchor,center,BOT,CENTER);
	attachable(anchor,spin,orient, r1=r1, r2=r2, l=l) {
		zrot(90+(realign?180/sides:0)) {
			if (!any_defined([chamfer, chamfer1, chamfer2, rounding, rounding1, rounding2])) {
				cylinder(h=l, r1=r1*sc, r2=r2*sc, center=true, $fn=sides);
			} else {
				vang = atan2(l, r1-r2)/2;
				chang1 = 90-first_defined([chamfang1, chamfang, vang]);
				chang2 = 90-first_defined([chamfang2, chamfang, 90-vang]);
				cham1 = first_defined([chamfer1, chamfer]) * (from_end? 1 : tan(chang1));
				cham2 = first_defined([chamfer2, chamfer]) * (from_end? 1 : tan(chang2));
				fil1 = first_defined([rounding1, rounding]);
				fil2 = first_defined([rounding2, rounding]);
				if (chamfer != undef) {
					assert(chamfer <= r1,  "chamfer is larger than the r1 radius of the cylinder.");
					assert(chamfer <= r2,  "chamfer is larger than the r2 radius of the cylinder.");
				}
				if (cham1 != undef) {
					assert(cham1 <= r1,  "chamfer1 is larger than the r1 radius of the cylinder.");
				}
				if (cham2 != undef) {
					assert(cham2 <= r2,  "chamfer2 is larger than the r2 radius of the cylinder.");
				}
				if (rounding != undef) {
					assert(rounding <= r1,  "rounding is larger than the r1 radius of the cylinder.");
					assert(rounding <= r2,  "rounding is larger than the r2 radius of the cylinder.");
				}
				if (fil1 != undef) {
					assert(fil1 <= r1,  "rounding1 is larger than the r1 radius of the cylinder.");
				}
				if (fil2 != undef) {
					assert(fil2 <= r2,  "rounding2 is larger than the r1 radius of the cylinder.");
				}
				dy1 = abs(first_defined([cham1, fil1, 0]));
				dy2 = abs(first_defined([cham2, fil2, 0]));
				assert(dy1+dy2 <= l, "Sum of fillets and chamfer sizes must be less than the length of the cylinder.");

				path = concat(
					[[0,l/2]],

					!is_undef(cham2)? (
						let(
							p1 = [r2-cham2/tan(chang2),l/2],
							p2 = lerp([r2,l/2],[r1,-l/2],abs(cham2)/l)
						) [p1,p2]
					) : !is_undef(fil2)? (
						let(
							cn = find_circle_2tangents([r2-fil2,l/2], [r2,l/2], [r1,-l/2], r=abs(fil2)),
							ang = fil2<0? phi : phi-180,
							steps = ceil(abs(ang)/360*segs(abs(fil2))),
							step = ang/steps,
							pts = [for (i=[0:1:steps]) let(a=90+i*step) cn[0]+abs(fil2)*[cos(a),sin(a)]]
						) pts
					) : [[r2,l/2]],

					!is_undef(cham1)? (
						let(
							p1 = lerp([r1,-l/2],[r2,l/2],abs(cham1)/l),
							p2 = [r1-cham1/tan(chang1),-l/2]
						) [p1,p2]
					) : !is_undef(fil1)? (
						let(
							cn = find_circle_2tangents([r1-fil1,-l/2], [r1,-l/2], [r2,l/2], r=abs(fil1)),
							ang = fil1<0? 180-phi : -phi,
							steps = ceil(abs(ang)/360*segs(abs(fil1))),
							step = ang/steps,
							pts = [for (i=[0:1:steps]) let(a=(fil1<0?180:0)+(phi-90)+i*step) cn[0]+abs(fil1)*[cos(a),sin(a)]]
						) pts
					) : [[r1,-l/2]],

					[[0,-l/2]]
				);
				rotate_extrude(convexity=2, $fn=sides) {
					polygon(path);
				}
			}
		}
		children();
	}
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
