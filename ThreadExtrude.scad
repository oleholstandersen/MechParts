use <ThreadBase.scad>;

inch = 25.4;

function bsp_profile(iSize) = 
    let (h = bsp_h_basic(iSize), y = bsp_h_basic(iSize)*tan(55/2), p = bsp_pitch(iSize), d = bsp_d_major(iSize)) [
        [d/2-1.5*h,0],
        [d/2-h,0],
        [d/2-h,p/4-y/2],
        [d/2,p/4+y/2],
        [d/2,3*p/4-y/2],
        [d/2-h,3*p/4+y/2],
        [d/2-h,p],
        [d/2-1.5*h,p]
    ];

function metric_profile(d = 10, pitch = 1.5) = 
    let (h = pitch*sqrt(3)/2) [
        [d/2-5*h/8,pitch/8], 
        [d/2,7*pitch/16], 
        [d/2,9*pitch/16], 
        [d/2-5*h/8,7*pitch/8]
    ];

/*
function metric_profile(d = 10, pitch = 1.5) = 
    let (h = pitch*sqrt(3)/2) [
        [d/2-7*h/8,0],
        [d/2-5*h/8,0],
        [d/2-5*h/8,pitch/8], 
        [d/2,7*pitch/16], 
        [d/2,9*pitch/16], 
        [d/2-5*h/8,7*pitch/8],
        [d/2-5*h/8,pitch],
        [d/2-7*h/8,pitch]
    ];
*/

function metric_d_min(d = 10, pitch = 1.5) = d-sqrt(3)*5/8*pitch+0.1*pitch;

function fragments() = $fn < 18 ? 18 : $fn;

module thread_segment(threadProfilePolygon = metric_profile(), pitch = 2)
{
    for (v = threadProfilePolygon)
    {
        assert(v[0] > 0, "All points of thread profile polygon must have positive x values");
    }
    polPoints = len(threadProfilePolygon);
    assert(polPoints > 0, "Thread profile polygon must have at least 3 points");
    fn = fragments();
    faces = concat(
        [[for (j = [1:polPoints]) polPoints-j]], 
        [[for (j = [0:polPoints-1]) polPoints+j]],
        [for (j = [0:polPoints-1]) [j,(j+1) % polPoints,((j+1) % polPoints)+polPoints,j+polPoints]]);
    //multiplication by 1.001 ensures, that segments overlap by 0.1 % anglewise
    points = concat(
        [for (v = threadProfilePolygon) [v[0],0,v[1]]],
        [for (v = threadProfilePolygon) [cos(1.001*360/fn)*v[0],sin(1.001*360/fn)*v[0],v[1]+pitch/fn]]);
    polyhedron(faces = faces, points = points);    
}

*thread_segment($fn = 72);

module thread_extrude(threadProfilePolygon = metric_profile(), pitch = 1.5, angle = 720)
{
    fn = fragments();
    segmentCount = ceil(fn*angle/360);
    assert(segmentCount > 0, "Angle must be positive")
    for (i = [0:segmentCount-1])
    {
        rotate(a = i*360/fn) 
        {
            translate([0,0,i*pitch/fn]) 
            {
                thread_segment(threadProfilePolygon = threadProfilePolygon, pitch = pitch);
            }
        }
    }
}

module metric_thread(d = 10, pitch = 1.5, h = 15)
{
    assert(pitch!=0, "Pitch cannot be 0");
    assert(h > 0, "Height must be positive");
    intersection()
    {
        translate([0,0,-pitch]) {thread_extrude(metric_profile(d, pitch), pitch, 360*h/pitch+360);}
        cylinder(d = d, h = h);
    }
}

module bspp_thread(iSize = 1/4, h = 20)
{
    assert(h > 0, "Height must be positive");
    intersection()
    {
        pitch = bsp_pitch(iSize);
        translate([0,0,-pitch]) {thread_extrude(bsp_profile(iSize), pitch, 360*h/pitch+360);}
        cylinder(d = bsp_d_major(iSize), h = h);
    }
}

*thread_extrude($fn = 36, angle = 3600);

*metric_thread(h = 3, $fn = 36);

*translate([0,0,20]) {metric_thread(pitch = -1.5, h = 3, $fn = 36);}
*difference()
{
    translate([0,0,-1]) {cylinder(d = 12, h = 6);}
    translate([0,0,-1]) {cylinder(d = 8, h = 7);}
    thread_extrude($fn = 36);
}

pitch = 1.5;
for (i = [0:3])
{
    translate([0,0,i*pitch]) {render() {thread_extrude(pitch = pitch, angle = 360, $fn = 72);}}
}
