module spindle_motor_775()
{
    render()
    {
        cylinder(d = 5, h = 95);
        translate([0,0,20-4.5]) {cylinder(d = 15, h = 4.5);}
        translate([0,0,20]) 
        {
            difference()
            {
                cylinder(d = 42, h = 66.5);
                for (a = [0,180])
                {
                    rotate(a)
                    {
                        translate([29/2,0,-1]) {cylinder(d = 4, h = 11);}
                    }
                }
                for (a = [0:90:270])
                {
                    rotate(a)
                    {
                        rotate(15)
                        {
                            rotate_extrude(angle = 60)
                            {
                                translate([29/2,0]) {square([4,2], center = true);} 
                            }
                            translate([0,0,5+36+5])
                            {
                                rotate_extrude(angle = 60)
                                {
                                    translate([42/2,0]) {circle(d = 4);}
                                }
                            }
                        }
                    }
                }
            }
        }
        translate([0,0,20+5]) 
        {
            linear_extrude(36)
            {
                difference()
                {
                    circle(d = 44);
                    square([3.2,44],true);
                }
            }
        }
        translate([0,0,20+66.5]) {cylinder(d = 15, h = 6.5);}
        for (a = [0,180])
        {
            rotate(a)
            {
                translate([34.5/2,-4.85/2,20+66.5]) {cube([0.6,4.85,8.9]);}
            }
        }
    }
}

module nema_17(l = 42,lower_axle_l = 0)
{
    cylinder(d = 22, h = 2);
    cylinder(d = 5, h = 24);
    if (lower_axle_l>0)
    {
        translate([0,0,-l-lower_axle_l]) {cylinder(d = 5, h = lower_axle_l+1);}
    }
    translate([0,0,-l])
    {
        linear_extrude(l)
        {
            difference()
            {
                intersection()
                {
                    square(42.3*[1,1], center = true);
                    rotate(45)
                    {
                        square((sqrt(2)*31+9)*[1,1], center = true);
                    }
                }
                for (x = 31/2*[-1,1])
                {
                    for (y = 31/2*[-1,1])
                    {
                        translate([x,y]) {circle(d = 3);}
                    }
                }
            }
        }
    }
}

module mst_motor_coupling(D1 = 5, D2 = 8, A = 20, W = 25, F = 3, M = 3, L = 7.5)
{
    render()
    {
        difference()
        {
            union()
            {
                linear_extrude(L) {difference() {circle(d = A);circle(d = D1);}}
                translate([0,0,L]) linear_extrude(W-2*L) {difference() {circle(d = A);circle(d = 2*A/3);}}
                translate([0,0,W-L]) linear_extrude(L) {difference() {circle(d = A);circle(d = D2);}}
            }
            for (z = [F,W-F], a = [0,90])
            {
                rotate(a) {translate([0,0,z]) {rotate(90,[1,0,0]) {cylinder(d = M, h = A);}}}
            }
            dz = (W-2*L)/17;
            for (i = [0:8])
            {
                rotate(i * 90) {translate([-A/2,-A/4,2*i*dz+L]) {cube([A,A,dz]);}}
            }
        }
    }
}

mst_motor_coupling($fn = 36);