use <ThreadBase.scad>;
use <ThreadExtrude.scad>;

module generic_metric_bolt(d, L, b, generate_thread = !$preview)
{
    s = bolt_s(d);
    k = bolt_k(d);
    d_min = metric_d_min(d);
    translate([0,0,-k]) {linear_extrude(k) {polygon([for (a = [60:60:360]) s/(2*cos(30))*[sin(a),cos(a)]]);}}
    cylinder(d = d, h = L-b-d+d_min);
    translate([0,0,L-b-d+d_min]) 
    {
        cylinder(d1 = d, d2 = d_min, h = d-d_min);
        if (generate_thread) {metric_thread(d, pitch(d), b+d-d_min);}
    }
    translate([0,0,L-b]) {cylinder(d = d_min, h = b);}
}

module din931_bolt(d, L, generate_thread = !$preview)
{
    generic_metric_bolt(d, L, bolt_b(d,L), generate_thread);
}

*din931_bolt(8, 200);

module nut_pinol_drill_tool(d_nut = 8, d_pinol = 3)
{
    render()
    {
        difference()
        {
            rotate(90,[1,0,0])
            {
                translate([0,0,-nut_m(d_nut)/2])
                {
                    linear_extrude(nut_m(d_nut))
                    {
                        difference()
                        {
                            square((nut_s(d_nut)+8*nut_m(d_pinol))*[1,1], center = true);
                            nut_profile(d_nut);
                        }
                    }
                }
            }
            for (z = [nut_s(d_nut)/2,nut_s(d_nut)/2+3*nut_m(d_pinol)])
            {
                translate([0,0,z]) {linear_extrude(nut_m(d_pinol)) {nut_profile(d_pinol);}}
            }
            #cylinder(d = d_pinol, h = nut_s(d_nut)/2+4*nut_m(d_pinol));
        }
    }
}

nut_pinol_drill_tool($fn = 16);
