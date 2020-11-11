sizes = [
    ["LM6UU",[6,12,19,13.5,1.1,11.5]],
    ["LM8SUU",[8,15,17,11.5,1.1,14]],
    ["LM8UU",[8,15,24,17.5,1.1,14]],
    ["LM10UU",[10,19,29,22,1.3,18]],
    ["LM12UU",[12,21,30,23,1.3,20]],
    ["LM13UU",[13,23,32,23,1.3,22]],
    ["LM16UU",[16,28,37,26.5,1.6,27]],
    ["LM20UU",[20,32,42,30.5,1.6,31]],
    ["LM6LUU",[6,12,35,27,1.1,11.5]],
    ["LM8LUU",[8,15,45,35,1.1,14]],
    ["LM10LUU",[10,19,55,44,1.3,18]],
    ["LM12LUU",[12,21,57,46,1.3,20]],
    ["LM13LUU",[13,23,61,46,1.3,22]],
    ["LM16LUU",[16,28,70,53,1.6,27]],
    ["LM20LUU",[20,32,80,61,1.6,31]]
];

function types() = [for (i = [0 : len(sizes)-1]) sizes[i][0]];

function lb_sizes(type) = sizes[search([type], sizes, num_returns_per_match = 1, index_col_num = 0)[0]][1];

function lb_d(type) = lb_sizes(type)[0];
function lb_D(type) = lb_sizes(type)[1];
function lb_L(type) = lb_sizes(type)[2];
function lb_B(type) = lb_sizes(type)[3];
function lb_W(type) = lb_sizes(type)[4];
function lb_D1(type) = lb_sizes(type)[5];


module linear_bearing(type)
{
    d = lb_d(type);
    D = lb_D(type);
    L = lb_L(type);
    B = lb_B(type);
    W = lb_W(type);
    D1 = lb_D1(type);
    color("gray")
    {
        render()
        {
            translate([0,0,-L/2])
            {
                difference()
                {
                    linear_extrude(height = L) 
                    {
                        difference()
                        {
                            circle(d = D);
                            circle(d = d);
                        }
                    }
                    for (z = [(L-B)/2,(L+B)/2-W])
                    {
                        translate([0,0,z]) 
                        {
                            linear_extrude(W)
                            {
                                difference()
                                {
                                    circle(d = D);
                                    circle(d = D1);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

for (i = [0 : len(sizes)-1])
{
    translate([i*40,0,0]) 
    {
        if ($preview) {
            translate([0,20,0]) {rotate(90) {linear_extrude(2) {text(types()[i]);}}}
        }
        linear_bearing(types()[i]);
    }
}