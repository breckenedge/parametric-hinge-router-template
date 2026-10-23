// Parametric Hinge Mortise Router Template
// All user parameters are in INCHES; the model is generated in mm.
//
// The template sits on the door/jamb edge with the fence hooked over the face.
// A bearing-guided bit rides the template opening. The bearing sticks out past
// the cutter edge by bearing_overhang, so the cutter stops that far short of the
// template edge; the opening is enlarged by that amount on each side to give an
// exactly hinge-sized mortise. (A negative overhang = bearing smaller than bit.)

/* [Hinge] */
hinge_length = 2.0;        // along the door edge
hinge_width  = 0.5;        // from the door face into the edge (leaf width)
hinge_corner_radius = 0;   // 0 = square-corner hinge (corners will need chiseling)

/* [Router Bit] */
bit_diameter     = 0.5;    // cutter diameter
bearing_overhang = 0.125;  // how far the bearing extends beyond the cutter edge (per side)

/* [Template] */
plate_thickness = 0.375;   // must keep the bearing on the template at your cut depth
margin          = 1.5;     // plate material around the opening (each side)
fence_depth     = 0.75;    // how far the fence hangs down the door face
fence_thickness = 0.375;
door_thickness  = 1.75;    // used for the optional second fence
second_fence    = false;   // add a fence on the far face (locks onto door)
label           = true;    // engrave sizes on top
print_flat      = true;    // flip top-face-down on the bed for 3D printing

/* [Hidden] */
in = 25.4;
$fn = 64;
offset_in = -bearing_overhang;   // cutter cut relative to template edge, per side (+ = beyond)
bearing_diameter = bit_diameter + 2 * bearing_overhang;

L  = hinge_length * in;
W  = hinge_width * in;
o  = offset_in * in;
t  = plate_thickness * in;
m  = margin * in;
fd = fence_depth * in;
ft = fence_thickness * in;
dt = door_thickness * in;

plate_y = second_fence ? dt + m : W + m;   // plate extends across edge from face (y=0)
plate_x = L + 2 * m;

// Opening = mortise outline grown by the bearing overhang. Extends past the door face
// (y < 0, through the fence) so the cutter exits cleanly at the face.
open_len   = L - 2 * o;
open_inner = W - o;                // edge farthest from the face
open_r     = max(hinge_corner_radius * in - o, 0);

assert(open_len > bearing_diameter * in && open_inner > 0,
       "Bit/bearing combination too large for this hinge size");

module rounded_rect(size, r) {
    if (r <= 0) square(size);
    else translate([r, r]) offset(r) square([size[0] - 2*r, size[1] - 2*r]);
}

module opening() {
    ext = ft + 1;
    translate([m + o, -ext, -1])
        linear_extrude(t + fd + 2)
            union() {
                rounded_rect([open_len, open_inner + ext], open_r);
                // keep corners square on the face side
                square([open_len, ext + open_r]);
            }
}

module template() {
    difference() {
        union() {
            // plate on the door edge
            cube([plate_x, plate_y, t]);
            // fence on the near face, hanging down
            translate([0, -ft, -fd]) cube([plate_x, ft, fd + t]);
            if (second_fence)
                translate([0, dt, -fd]) cube([plate_x, ft, fd + t]);
        }
        opening();
        if (label)
            translate([plate_x / 2, W + (plate_y - W) / 2, t - 0.6])
                linear_extrude(1)
                    text(str(hinge_length, "\" x ", hinge_width, "\"  bit ",
                             bit_diameter, " brg ", bearing_diameter),
                         size = min(5, (plate_y - W) / 3), halign = "center",
                         valign = "center");
    }
}

// Print orientation: flip so the plate's top face is on the bed and the fence points up.
if (print_flat)
    translate([0, 0, t]) rotate([180, 0, 0]) template();
else
    template();

echo(str("Template opening: ", open_len / in, "\" x ", open_inner / in,
         "\" (bearing overhang ", bearing_overhang, "\" per side)"));
