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

for (mSize = [3:12], L = [50, 150, 250])
{
    echo("M,L,b",mSize,L,bolt_b(mSize,L));
}

din931_bolt(8, 200);
