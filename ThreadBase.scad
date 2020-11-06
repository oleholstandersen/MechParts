function hex_cap_screw_dk(mSize) = lookup(
    mSize,
    [   [2,3.98],
        [2.5,4.68],
        [3,5.68],
        [4,7.22],
        [5,8.72],
        [6,10.22],
        [8,13.27],
        [10,16.27],
        [12,18.27]]);

function nut_s(mSize) = lookup(
    mSize,
    [   [ 2  , 4  ],
        [ 2.5, 5  ],
        [ 3  , 5.5],
        [ 4  , 7  ],
        [ 5  , 8  ],
        [ 6  ,10  ],
        [ 8  ,13  ],
        [10  ,17  ],
        [12  ,19  ]]);

function lock_nut_h(mSize) = lookup(
    mSize,
    [   [ 2  , 2.8],
        [ 2.5, 3  ],
        [ 3  , 3.9],
        [ 4  , 5  ],
        [ 5  , 5  ],
        [ 6  , 5.9],
        [ 8  , 7.9],
        [10  , 9.8],
        [12  ,12  ]]);

function nut_m(mSize) = lookup(
    mSize,
    [   [ 2  , 1.6],
        [ 2.5, 2  ],
        [ 3  , 2.4],
        [ 4  , 3.2],
        [ 5  , 4  ],
        [ 6  , 5  ],
        [ 8  , 6.5],
        [10  , 8  ],
        [12  ,10  ]]);

function bolt_s(mSize) = nut_s(mSize);


function bolt_k(mSize) = lookup(
    mSize,
    [   [ 3, 2.12],
        [ 4, 2.92],
        [ 5, 3.65],
        [ 6, 4.15],
        [ 8, 5.45],
        [10, 6.58],
        [12, 7.68]]);


function bolt_b(mSize, L) = let (
bolt_b_values = [   
    [ 3,[12]],
    [ 4,[14]],
    [ 5,[16,22]],
    [ 6,[18,24]],
    [ 8,[22,28]],
    [10,[26,32,45]],
    [12,[30,36,49]]]) bolt_b_values[search(mSize,bolt_b_values)[0]][1][L>200?2:(L>125?1:0)];

function pitch(mSize) = lookup(
    mSize,
    [   [2,0.4],
        [2.5,0.45],
        [3,0.5],
        [4,0.7],
        [5,0.8],
        [6,1],
        [8,1.25],
        [10,1.5],
        [12,1.75],
        [14,2],
        [16,2],
        [18,2.5],
        [20,2.5]]);

module nut_profile(mSize = 5, axis = "z", revDir = false)
{
    orient_to_axis(axis = axis, revDir = revDir)
    {
        d = nut_s(mSize)/sin(60);
        points = [for (a = [60:60:360]) d/2 * [cos(a), sin(a)]]; 
        polygon(points);
    }
}

inch = 25.4;

function bsp_tpi(iSize) = lookup(
    iSize,
    [   [1/16,28],
        [1/8,28],
        [1/4,19],
        [3/8,19],
        [1/2,14],
        [3/4,14],
        [1,11],
        [1.25,11],
        [1.5,11],
        [2,11],
        [2.5,11],
        [3,11],
        [4,11],
        [5,11],
        [6,11]]);

function bsp_pitch(iSize) = inch/bsp_tpi(iSize);

function bsp_d_major(iSize) = lookup(
    iSize,
    [   [1/16,7.723],
        [1/8,9.728],
        [1/4,13.157],
        [3/8,16.662],
        [1/2,20.995],
        [3/4,26.441],
        [1,33.249],
        [1.25,41.910],
        [1.5,47.803],
        [2,59.614],
        [2.5,75.184],
        [3,87.884],
        [4,113.03],
        [5,138.430],
        [6,163.830]]);

function bsp_h_v(iSize) = bsp_pitch(iSize)/(2*tan(55/2));

function bsp_h_basic(iSize) = 2*bsp_h_v(iSize)/3;

function bsp_d_minor(iSize) = bsp_d_major(iSize)-2*bsp_h_basic(iSize);

module orient_to_axis(axis = "x", revDir = false)
{
    if (axis=="x")
    {
        rotate(a = 90, v = [0,1,0]) orient_to_axis(axis = "z",revDir=revDir) {children();};
    }
    else if (axis=="y")
    {
        rotate(a = -90, v = [1,0,0]) orient_to_axis(axis = "z",revDir=revDir) {children();};
    }
    else if (axis=="z")
    {
        rotate(a = revDir ? 180 : 0, v = [1,0,0]) {children();}
    }
    else
    {
        assert(false,str("unknown axis ",axis));
    }
}
