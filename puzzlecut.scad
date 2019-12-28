// OpenSCAD Puzzlecut library
// Author: Matthew Fallshaw
// Source: https://github.com/matthewfallshaw/os_puzzlecut.git

// Public Constants
PC_MALE=1;
PC_FEMALE=0;
PC_X=[1,0,0];
PC_Y=[0,1,0];
PC_Z=[0,0,1];

// Private Constants
FIT_CLEARANCE=0.25;

// puzzle_cut module
// cuts away one of the positive axes and adds (male or female) joining pins/holes
// @param {number} pin_dia - diameter of joining pins
// @param {number} pin_length - length of joining pins
// @param {PC_MALE|PC_FEMALE} sex - male (pin) or female (hole)
// @param {PC_X|PC_Y|PC_Z} axis - which positive axis will be cut
// @param {Array.<Array.<number>>} [pins_v=[[0,0]]] - vector of pin locations ([[y,z]] for PC_X, etc.)
// @param {integer} [$fn=7] - facets
// @param {number} [fit_clearance=0.25] - extra size for the fit hole
// @param {number} [line_width=0.45] - printed line width
// @param {number} [cut_size=10000] - bounding cut cube size
module puzzle_cut(pin_dia=8,pin_length=8,sex=PC_MALE,axis=PC_X,pins_v=[[0,0]],
                  $fn=7,fit_clearance=FIT_CLEARANCE,line_width=0.45,cut_size=10000)
{
  difference() {
    children();
    if (sex) {
      difference() {
        cut_cube(sex,cut_size);
        cut_pins(pin_dia,pin_length,sex,pins_v,$fn,fit_clearance,line_width);
      }
    }
    else {
      union() {
        cut_cube(sex,cut_size);
        cut_pins(pin_dia,pin_length,sex,pins_v,$fn,fit_clearance,line_width);
      }
    }
  }
}

module cut_cube(sex,cut_size)
{
  rotate(sex ? 0 : 180) translate([0,-cut_size/2,-cut_size/2]) cube(cut_size);
}

module cut_pins(pin_dia,pin_length,sex,pins_v,$fn,fit_clearance,line_width)
{
  for (p=pins_v) {
    translate([-pin_length,p[0],p[1]])
      pin(pin_dia=pin_dia,pin_length=pin_length*2,sex=sex,
          $fn=$fn,fit_clearance=fit_clearance,line_width=line_width);
  }
}

module pin(pin_dia=8,pin_length=8,sex=PC_MALE,$fn=7,fit_clearance,line_width=0.45)
{
  slot=ceil(pin_dia/6/line_width)*line_width;
  difference() {
    rotate([180,0,0]) beam(l=pin_length,d=pin_dia+(sex?0:fit_clearance),n=$fn);
    if(sex) translate([-1,-slot/2,0]) cube([pin_length+2,slot,pin_dia]);
  }
}

module beam(l,d,n) {
  rotate([0,90]) rotate([0,0,360/(n*2)]) cylinder(h=l,d=d,$fn=n);
}


/*
// Example
cut=210;
translate([cut,0]) puzzle_cut(pin_dia=4,pin_length=8,sex=PC_MALE,axis=PC_X)   translate([-cut,0])
  forked_beam();
translate([0,50])  puzzle_cut(pin_dia=4,pin_length=8,sex=PC_FEMALE,axis=PC_X) translate([-cut,0])
  forked_beam();
*/
