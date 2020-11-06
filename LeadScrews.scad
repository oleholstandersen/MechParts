use <ThreadExtrude.scad>;

$fs = 0.5;

module T8_lead_screw(l)
{
    color("gray") {cylinder(d = 8, l);}
    //TO-DO: perhaps make thread
}

module T8_cyl_nut_flange()
{
    linear_extrude(4) 
    {
        difference()
        {
            circle(d = 22);
            circle(d = 8);
            for (a = [0:90:270])
            {
                rotate(a) {translate([8,0]) {circle(d = 3.6);}}
            }
        }
    }
}

module T8_cyl_anti_backlash_nut_a()
{
    T8_cyl_nut_flange();
    translate([0,0,4]) {linear_extrude(7) {difference() {circle(d = 10.3);circle(d = 8);}}}
    translate([0,0,11]) 
    {
        linear_extrude(4) 
        {
            difference() 
            {
                circle(d = 10.3);
                circle(d = 8);
                square([10.3,3.8],center = true);
            }
        }
    }
}

module T8_cyl_anti_backlash_nut_b()
{
    linear_extrude(4)
    {
        intersection()
        {
            square([10.3,3.6],center = true);
            difference()
            {
                circle(d = 10.3);
                circle(d = 8);
            }
        }
    }
    translate([0,0,4]) linear_extrude(7) {difference() {circle(d = 10.3);circle(d = 8);}}
    translate([0,0,11]) linear_extrude(4) {{difference() {circle(d = 14);circle(d = 8);}}}
}

module spring(D = 11, d = 1, h = 19, turns = 6)
{
    render()
    {
        hex = [for (i = [0:5]) 0.5*[D+d*sin(i*60),d*cos(i*60)]];
        for (z = [0,h]) 
        {
            translate([0,0,z]) {rotate_extrude() {polygon(hex);}}
        }
        thread_extrude(hex,h/turns,turns*360);
    }
}

module T8_cyl_anti_backlash_nut()
{
    T8_cyl_anti_backlash_nut_a();
    translate([0,0,13]) {T8_cyl_anti_backlash_nut_b();}
    translate([0,0,4.5]) {color("gray") {spring(11,1,19,6);}}
}

module T8_cyl_nut()
{
    T8_cyl_nut_flange();
    translate([0,0,4]) {linear_extrude(11) {difference() {circle(d = 10.3);circle(d = 8);}}}
}

T8_cyl_nut();