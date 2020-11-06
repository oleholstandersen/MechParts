mgn_assembly_sizes = [
    [ 3,[ 4,1,2.5  ]],
    [ 7,[ 8,1.5,5  ]],
    [ 9,[10,2.0,5.5]],
    [12,[13,3.0,7.5]],
    [15,[16,4.0,8.5]]
];
function mgn_assembly_size(size) = mgn_assembly_sizes[search([size], mgn_assembly_sizes, num_returns_per_match = 1, index_col_num = 0)[0]][1];
function mgn_H(size) = mgn_assembly_size(size)[0];
function mgn_H1(size) = mgn_assembly_size(size)[1];
function mgn_N(size) = mgn_assembly_size(size)[2];

mgn_block_sizes = [
    [ "3C",[ 8, 0,0  , 3.5, 7  ,11.3,  0,  0,1.6,1.3,0  ]],
    [ "3H",[ 8, 0,0  , 5.5,11  ,15.3,  0,  0,2  ,1.3,0  ]],
    [ "7C",[17,12,2.5, 8  ,13.5,22.5,  0,1.2,2  ,2.5,1.5]],
    [ "7H",[17,12,2.5,13  ,21.8,30.8,  0,1.2,2  ,2.5,1.5]],
    [ "9C",[20,15,2.5,10  ,18.9,28.9,  0,1.4,3  ,3  ,1.8]],
    [ "9H",[20,15,2.5,16  ,29.9,39.9,  0,1.4,3  ,3  ,1.8]],
    ["12C",[27,20,3.5,15  ,21.7,34.7,  0,2  ,3  ,3.5,2.5]],
    ["12H",[27,20,3.5,20  ,32.4,45.4,  0,2  ,3  ,3.5,2.5]],
    ["15C",[32,25,3.5,20  ,26.7,42.1,4.5,3  ,3  ,4  ,3  ]],
    ["15H",[32,25,3.5,25  ,43.4,58.8,4.5,3  ,3  ,4  ,3  ]]
];
function mgn_block_size(type) = mgn_block_sizes[search([type], mgn_block_sizes, num_returns_per_match = 1, index_col_num = 0)[0]][1];
function mgn_W(type) = mgn_block_size(type)[0];
function mgn_B(type) = mgn_block_size(type)[1];
function mgn_B1(type) = mgn_block_size(type)[2];
function mgn_C(type) = mgn_block_size(type)[3];
function mgn_L1(type) = mgn_block_size(type)[4];
function mgn_L(type) = mgn_block_size(type)[5];
function mgn_G(type) = mgn_block_size(type)[6];
function mgn_Gn(type) = mgn_block_size(type)[7];
function mgn_M(type) = mgn_block_size(type)[8];
function mgn_l(type) = mgn_block_size(type)[9];
function mgn_H2(type) = mgn_block_size(type)[10];

mgn_rail_sizes = [
    [ 3,[ 3, 2.6,1.6,2.6,1.6,10, 5  ,0.1]],
    [ 7,[ 7, 4.8,4.2,2.3,2.4,15, 5  ,0.2]],
    [ 9,[ 9, 6.5,6  ,3.5,3.5,20, 7.5,0.2]],
    [12,[12, 8,  6  ,4.5,3.5,25,10  ,0.3]],
    [15,[15,10  ,6  ,4.5,3.5,40,15  ,0.5]]
];
function mgn_rail_size(size) = mgn_rail_sizes[search([size], mgn_rail_sizes, num_returns_per_match = 1, index_col_num = 0)[0]][1];
function mgn_WR(size) = mgn_rail_size(size)[0];
function mgn_HR(size) = mgn_rail_size(size)[1];
function mgn_D(size) = mgn_rail_size(size)[2];
function mgn_h(size) = mgn_rail_size(size)[3];
function mgn_d(size) = mgn_rail_size(size)[4];
function mgn_P(size) = mgn_rail_size(size)[5];
function mgn_E(size) = mgn_rail_size(size)[6];
function mgn_r1(size) = mgn_rail_size(size)[7];
function mgn_Db(size) = (3*(mgn_HR(size)-mgn_H1(size))/5+2*mgn_r1(size))/sqrt(2);

module mgn_rail_profile(size)
{
    H = mgn_H(size);
    HR = mgn_HR(size);
    WR = mgn_WR(size);
    r1 = mgn_r1(size);
    s = HR-mgn_H1(size);
    upper_half = [
        [0,WR/2-r1],
        [-r1,WR/2],
        [-HR+4*s/5,WR/2],
        [-HR+3*s/5,WR/2-s/5],
        [-HR+3*s/5,WR/2-2*s/5],
        [-HR+2*s/5,WR/2-2*s/5],
        [-HR+2*s/5,WR/2-s/5],
        [-HR+s/5,WR/2],
        [-HR+r1,WR/2],
        [-HR,WR/2-r1]];
    polygon(concat(upper_half, [for(i = [len(upper_half)-1:-1:0]) [upper_half[i][0],-upper_half[i][1]]]));
}

function mgn_rail_length(size, n) = 2*mgn_E(size)+(n-1)*mgn_P(size);


module mgn_rail(size,n)
{
    assert(n==floor(n),"n must be an integer");
    assert(n>0,"n must be postitve");
    assert(is_list(mgn_rail_size(size)),"not a known size");
    E = mgn_E(size);
    P = mgn_P(size);
    h = mgn_h(size);
    HR = mgn_HR(size);
    color("lightgray")
    {
        render()
        {
            difference()
            {
                rotate(90,[0,1,0])
                {
                    linear_extrude(mgn_rail_length(size, n)) {mgn_rail_profile(size);}
                }
                for (i = [0:n-1])
                {
                    translate([E+i*P,0,-1])
                    {
                        cylinder(d = mgn_d(size), h = HR+2-h);
                        translate([0,0,HR-h+1]) {cylinder(d = mgn_D(size), h = h+1);}
                    }
                }
            }
        }    
    }
}

module mgn_bearing_profile(size)
{
    H = mgn_H(size);
    HR = mgn_HR(size);
    WR = mgn_WR(size);
    r1 = mgn_r1(size);
    H1 = mgn_H1(size);
    W = mgn_W(str(size,"C"));
    upper_half = [
        [-HR-r1, WR/2],
        [-HR,WR/2+r1],
        [-H1-r1,WR/2+r1],
        [-H1,WR/2+2*r1],
        [-H1,W/2-r1],
        [-H1-r1,W/2],
        [-H+r1,W/2],
        [-H,W/2-r1]
    ];
    polygon(concat(upper_half, [for(i = [len(upper_half)-1:-1:0]) [upper_half[i][0],-upper_half[i][1]]]));
}

module mgn_bearing_profile_ends(size)
{
    HR = mgn_HR(size);
    WR = mgn_WR(size);
    r1 = mgn_r1(size);
    H1 = mgn_H1(size);
    W = mgn_W(str(size,"C"));
    H = mgn_H(size)-r1;//bearing not as high at ends
    upper_half = [
        [-HR-r1, WR/2],
        [-HR,WR/2+r1],
        [-H1-r1,WR/2+r1],
        [-H1,WR/2+2*r1],
        [-H1,W/2-r1],
        [-H1-r1,W/2],
        [-H+r1,W/2],
        [-H,W/2-r1]
    ];
    polygon(concat(upper_half, [for(i = [len(upper_half)-1:-1:0]) [upper_half[i][0],-upper_half[i][1]]]));
}

module mgn_bearing(size, subtype = "H")
{
    L = mgn_L(str(size, subtype));
    L1 = mgn_L1(str(size, subtype));
    Db = mgn_Db(size);
    HR = mgn_HR(size);
    WR = mgn_WR(size);
    r1 = mgn_r1(size);
    H1 = mgn_H1(size);
    l = mgn_l(str(size, subtype));
    H = mgn_H(size);
    rotate(90,[0,1,0])
    {
        for (z = [-L/2,L1/2]) 
        {
            translate([0,0,z]) {color("gray") {linear_extrude((L-L1)/2) {mgn_bearing_profile_ends(size);}}}
        }
    }
    color("lightgray")
    {
        render()
        {
            difference()
            {
                rotate(90,[0,1,0])
                {
                    translate([0,0,-L1/2]) {linear_extrude(L1) {mgn_bearing_profile(size);}}
                }
                for (x = mgn_C(str(size, subtype))/2*[-1,1], y = mgn_B(str(size, subtype))/2*[-1,1])
                {
                    translate([x,y,H-l]) {cylinder(d = mgn_M(size), h = l+1);}
                }
            }
        }
    }
    n_ball = floor(L1/Db);
    for (i = [(1-n_ball)/2:(n_ball-1)/2], j = [-1,1])
    {
        translate([i*Db,j*(WR/2+r1),(HR+H1)/2]) {color("white") {sphere(d = Db);}}
    }
}

function sum(arr, i = 0, r = 0) = i < len(arr) ? sum(arr, i+1, r + arr[i]) : r;

sizes = [3, 7, 9, 12, 15];
for (i = [0:len(sizes)-1])
{
    type = str(sizes[i],"C");
    translate([0,i==0?0:sum([for (j = [1:i]) 2*mgn_W(str(sizes[j],"C"))/2])]) 
    {
        mgn_bearing(sizes[i],$fn = 36);
        translate([-mgn_rail_length(sizes[i],10)/2,0,0]) {mgn_rail(sizes[i],10,$fn = 36);}
    }
}