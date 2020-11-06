module beam_profile(series, size)
{
    import(str("SquareBeamsDXF/",series,"-",size,".dxf"));
}

module beam(series = "vslot", size = 2020, length = 200)
{
    linear_extrude(length) {beam_profile(series, size);}
}

beam("vslot", "4080-cbeam", 200);