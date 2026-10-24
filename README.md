# Parametric Hinge Router Template

An OpenSCAD model for a 3D-printable router template for cutting hinge mortises.
It sits on a door or jamb edge, with a fence hooked over the face, and guides a
bearing-guided router bit to cut a mortise the exact size of the hinge leaf.

Defaults: **2" × 0.5" hinge leaf**, **1/2" bit with a 3/4" bearing** (the bearing
extends 1/8" beyond the cutter edge).

## Usage

1. Open `hinge_router_template.scad` in OpenSCAD and set the parameters in the
   Customizer panel (all values in inches).
2. Render (F6) and export as STL (or from the command line:
   `openscad -o out/hinge_router_template.stl hinge_router_template.scad`).
3. Print it flat; with `print_flat = true` the template lies top-face-down with the fence pointing up.
4. Clamp the template to the door edge with the fence against the face, set the
   bit to stick out `bit_reach` below the router base, and rout clockwise inside
   the opening. The mortise comes out `cut_depth` deep.

The router bit leaves corners rounded to the cutter radius. Square them with a
chisel, or set `hinge_corner_radius` to match radius-corner hinges.

## Parameters

| Parameter | Default | Description |
|---|---|---|
| `hinge_length` | 2.0 | Hinge leaf length along the door edge |
| `hinge_width` | 0.5 | Leaf width from the door face into the edge |
| `hinge_corner_radius` | 0 | Corner radius of the hinge leaf (0 = square) |
| `bit_diameter` | 0.5 | Cutter diameter |
| `bearing_overhang` | 0.125 | How far the bearing extends beyond the cutter edge, per side. Negative if the bearing is smaller than the cutter. |
| `bit_reach` | 0.25 | How far the bit tip sticks out below the router base |
| `cut_depth` | 0.09375 | Mortise depth below the template underside (half the closed hinge thickness) |
| `router_base` | 6.0 | Router base diameter; sizes the lowered pocket the base rides in |
| `plate_thickness` | 0.375 | Rim thickness outside the router pocket |
| `margin` | 1.5 | Plate material around the opening |
| `fence_depth` | 0.75 | How far the fence hangs down the door face |
| `fence_thickness` | 0.375 | Fence thickness |
| `second_fence` | false | Add a fence on the opposite face to lock onto the door |
| `door_thickness` | 1.75 | Door thickness (only used with `second_fence`) |
| `label` | true | Engrave the sizes into the plate |
| `print_flat` | true | Flip the template for printing |

## How the bearing offset works

The template edge guides the bearing, not the cutter. The cutter stops short of
the template edge by the bearing overhang:

```
bearing_overhang = (bearing_diameter - bit_diameter) / 2
opening length   = hinge_length + 2 × bearing_overhang
opening width    = hinge_width  + bearing_overhang   (the face side is open)
```

## Common bit and bearing combinations

Template openings below are for the default 2" × 0.5" hinge. Check your own bit's
actual cutter and bearing diameters with calipers; they vary by manufacturer.

### Pattern / flush-trim bits (bearing = cutter)

| Bit diameter | Bearing diameter | `bit_diameter` | `bearing_overhang` | Opening (2" × 0.5" hinge) |
|---|---|---|---|---|
| 1/4" | 1/4" | 0.25 | 0 | 2.000" × 0.500" |
| 3/8" | 3/8" | 0.375 | 0 | 2.000" × 0.500" |
| 1/2" | 1/2" | 0.5 | 0 | 2.000" × 0.500" |
| 5/8" | 5/8" | 0.625 | 0 | 2.000" × 0.500" |
| 3/4" | 3/4" | 0.75 | 0 | 2.000" × 0.500" |

With zero overhang the opening is the same size as the hinge, so you can trace
the hinge directly onto the template.

### Oversize-bearing bits (bearing larger than cutter)

| Bit diameter | Bearing diameter | `bit_diameter` | `bearing_overhang` | Opening (2" × 0.5" hinge) |
|---|---|---|---|---|
| 1/4" | 3/8" | 0.25 | 0.0625 | 2.125" × 0.5625" |
| 1/4" | 1/2" | 0.25 | 0.125 | 2.250" × 0.625" |
| 3/8" | 1/2" | 0.375 | 0.0625 | 2.125" × 0.5625" |
| 3/8" | 5/8" | 0.375 | 0.125 | 2.250" × 0.625" |
| 1/2" | 5/8" | 0.5 | 0.0625 | 2.125" × 0.5625" |
| **1/2"** | **3/4"** | **0.5** | **0.125** | **2.250" × 0.625"** (default) |
| 1/2" | 7/8" | 0.5 | 0.1875 | 2.375" × 0.6875" |
| 3/4" | 1" | 0.75 | 0.125 | 2.250" × 0.625" |

### Template guide bushings (no bearing)

If you use a straight bit with a template guide bushing instead of a bearing, set
`bearing_overhang` to `(bushing OD - bit diameter) / 2`:

| Bit diameter | Bushing OD | `bearing_overhang` | Opening (2" × 0.5" hinge) |
|---|---|---|---|
| 1/4" | 5/16" | 0.03125 | 2.0625" × 0.53125" |
| 1/4" | 7/16" | 0.09375 | 2.1875" × 0.59375" |
| 1/4" | 1/2" | 0.125 | 2.250" × 0.625" |
| 3/8" | 5/8" | 0.125 | 2.250" × 0.625" |
| 1/2" | 5/8" | 0.0625 | 2.125" × 0.5625" |
| 1/2" | 3/4" | 0.125 | 2.250" × 0.625" |

### Notes on choosing a bit

- The opening is open on the door-face side, so the bearing can be wider than
  the hinge leaf. The opening length must still be larger than the bearing so it
  can reach both ends.
- Smaller cutters leave tighter corner radii (cutter diameter ÷ 2), which means less chiseling.
- Where the router base rides, the top face is lowered to a guide surface
  `bit_reach - cut_depth` thick (5/32" by default), so the bit cuts `cut_depth`
  into the door. The bearing must still contact that guide edge.
