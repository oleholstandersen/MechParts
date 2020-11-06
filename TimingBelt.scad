function pitch_diameter(nt) = 2*nt/PI;

function outer_diameter(nt) = pitch_diameter(nt)-0.51;

module pulley_profile(nt)
{
    $fn = 4*nt;
    A = 360/nt;
    od = outer_diameter(nt);
    r1 = (od/2-0.555)*cos(A/2);
    yy = 2*((od/2-0.555)*sin(A/2)-0.555);
    difference()
    {
        circle(r1);
        for (i = [0:nt-1])
        {
            rotate(i*A)
            {
                translate([od/2-0.555,0]) {circle(0.555);}
            }
        }
    }
    intersection()
    {
        circle(d = od);
        union()
        {
            for (i = [0:nt-1])
            {
                rotate((i+0.5)*A)
                {
                    translate([r1,0]) {square([od-2*r1-yy,yy],center = true);}
                    translate([(od-yy)/2,0]) {circle(d = yy);}
                }
            }
        }
    }
}

module pulley_flanges(fd, ad, lfh = 1, bh = 7, ufh = 1)
{
    linear_extrude(lfh)
    {
        difference()
        {
            circle(d = fd);
            circle(d = ad);
        }
    }
    translate([0,0,lfh+bh])
    {
        linear_extrude(ufh)
        {
            difference()
            {
                circle(d = fd);
                circle(d = ad);
            }

        }
    }
}

module idle_pulley(nt = 16, fd = 13, ad = 3, lfh = 1, bh = 7, ufh = 1)
{
    render()
    {
        $fn = $fn<4*nt?4*nt:$fn;
        pulley_flanges(fd, ad, lfh, bh, ufh);
        translate([0,0,lfh])
        {
            linear_extrude(bh) 
            {
                difference()
                {
                    pulley_profile(nt);
                    circle(d = ad);
                }
            }
        }
    }
}

module idle_pulley_smooth(bd = 9.75, fd = 13, ad = 3, lfh = 1, bh = 7, ufh = 1)
{
    render()
    {
        pulley_flanges(fd, ad, lfh, bh, ufh);
        translate([0,0,lfh])
        {
            linear_extrude(bh) 
            {
                difference()
                {
                    circle(d = bd);
                    circle(d = ad);
                }
            }
        }
    }
}

idle_pulley(16, 13, 6);