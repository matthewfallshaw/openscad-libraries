//////////////////////////////////////////////////////////////////////
// LibFile: vitamins.scad
//   Various vitamins (purchased parts).
// Includes:
//   include <stdlib.scad>
//   include <vitamins.scad>
//////////////////////////////////////////////////////////////////////

// Section: Functions


// Function: get_lmXuu_bearing_diam()
// Description: Get outside diameter, in mm, of a standard lmXuu bearing.
// Arguments:
//   size = Inner size of lmXuu bearing, in mm.



// Section: Bearings

include <NopSCADlib/vitamins/ball_bearings.scad>

// Module: ball_bearing()
// Description: Standard ball bearings.
// Arguments:
//   type = { BBSMR95, BB624, BB608, BB6200, BB6201, BB6808 }
//   anchor = Translate so anchor point is at origin (0,0,0).  See [anchor](attachments.scad#anchor).  Default: `CENTER`
//   spin = Rotate this many degrees around the Z axis after anchor.  See [spin](attachments.scad#spin).  Default: `0`
//   orient = Vector to rotate top towards, after spin.  See [orient](attachments.scad#orient).  Default: `UP`
// Example:
//   ball_bearing(BB608, anchor=BOTTOM);
module n_ball_bearing(type, anchor=CENTER, spin=0, orient=UP)
{
  attachable(d=bb_diameter(type),h=bb_width(type),anchor=anchor,spin=spin,orient=orient) {
    ball_bearing(type);
    children();
  }
}


// Section: GT2 Belts


GT2_pulley_20T=[20,[16,7.5],[undef,7],[16,1.3],[16,7.5+7+1.3]];
function GT2_teeth(type)=type[0];
function GT2_diameter(type)=type[4][0];
function GT2_height(type)=type[4][1];
function GT2_heights(type)=[type[1][1],type[2][1],type[3][1]];

// Module: GT2_pulley()
// Description: GT2 pullies.
// Arguments:
//   type = { GT2_pulley_20T }
//   anchor = Translate so anchor point is at origin (0,0,0).  See [anchor](attachments.scad#anchor).  Default: `CENTER`
//   spin = Rotate this many degrees around the Z axis after anchor.  See [spin](attachments.scad#spin).  Default: `0`
//   orient = Vector to rotate top towards, after spin.  See [orient](attachments.scad#orient).  Default: `UP`
// Example:
//   GT2_pulley(GT2_pulley_20T, anchor=BOTTOM);
module GT2_pulley(type,anchor=CENTER,spin=0,orient=UP) {
  assert(type);

  anchors=[anchorpt("geartop",   [0,0,type[4][1]/2-type[3][1]])
          ,anchorpt("gearbottom",[0,0,type[4][1]/2-type[3][1]-type[2][1]])
          ,anchorpt("gearcenter",[0,0,type[4][1]/2-type[3][1]-type[2][1]/2])
          ];

  attachable(d=type[4][0],l=type[4][1],anchor=anchor,spin=spin,orient=orient,anchors=anchors) {
    color("green") down(type[4][1]/2) difference() {
      union() {
        cyl(d=type[1][0],l=type[1][1],anchor=BOTTOM);
        up(type[1][1]) gear(pitch=pitch
                           ,teeth=type[0]
                           ,thickness=type[2][1]
                           ,shaft_diam=0
                           ,anchor=BOTTOM
                           );
        up(type[4][1]-type[3][1]) cyl(d=type[3][0],l=type[3][1],anchor=BOTTOM);
      }

      down(0.01) cyl(d=shaft_dia,l=type[4][1]+0.02,anchor=BOTTOM);
    }
    children();
  }
}


// Module: linear_bearing_housing()
// Description:
//   Creates a model of a clamp to hold a generic linear bearing cartridge.
// Arguments:
//   d = Diameter of linear bearing. (Default: 15)
//   l = Length of linear bearing. (Default: 24)
//   tab = Clamp tab height. (Default: 7)
//   tabwall = Clamp Tab thickness. (Default: 5)
//   wall = Wall thickness of clamp housing. (Default: 3)
//   gap = Gap in clamp. (Default: 5)
//   screwsize = Size of screw to use to tighten clamp. (Default: 3)
//   anchor = Translate so anchor point is at origin (0,0,0).  See [anchor](attachments.scad#anchor).  Default: `CENTER`
//   spin = Rotate this many degrees around the Z axis after anchor.  See [spin](attachments.scad#spin).  Default: `0`
//   orient = Vector torotate top towards, after spin.  See [orient](attachments.scad#orient).  Default: `UP`
// Example:
//   linear_bearing_housing(d=19, l=29, wall=2, tab=6, screwsize=2.5);
module linear_bearing_housing(d=15, l=24, tab=7, gap=5, wall=3, tabwall=5, screwsize=3, anchor=BOTTOM, spin=0, orient=UP)
{
}





// Section: Masking Modules



// Module: nema_mount_holes()
// Description: Creates a mask to use when making standard NEMA stepper motor mounts.
// Arguments:
//   size = The standard NEMA motor size to make a mount for.
//   depth = The thickness of the mounting hole mask.  Default: 5
//   l = The length of the slots, for making an adjustable motor mount.  Default: 5
//   anchor = Translate so anchor point is at origin (0,0,0).  See [anchor](attachments.scad#anchor).  Default: `CENTER`
//   spin = Rotate this many degrees around the Z axis after anchor.  See [spin](attachments.scad#spin).  Default: `0`
//   orient = Vector to rotate top towards, after spin.  See [orient](attachments.scad#orient).  Default: `UP`
//   $slop = The printer-specific lop value to make parts fit just right.
// Extra Anchors:
//   "screw1" = The center top of the screw hole/slot in the X+Y+ quadrant.
//   "screw2" = The center top of the screw hole/slot in the X-Y+ quadrant.
//   "screw3" = The center top of the screw hole/slot in the X-Y- quadrant.
//   "screw4" = The center top of the screw hole/slot in the X+Y- quadrant.
// Example:
//   nema_mount_holes(size=14, depth=5, l=5);
// Example:
//   nema_mount_holes(size=17, depth=5, l=5);
// Example:
//   nema_mount_holes(size=17, depth=5, l=0);
module nema_mount_holes(size=17, depth=5, l=5, anchor=CENTER, spin=0, orient=UP)
{
}
