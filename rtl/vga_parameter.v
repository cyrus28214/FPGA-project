parameter HS_sync = 96;
parameter HS_left = HS_sync + 40 + 8;
parameter HS_width = 640;
parameter HS_video = HS_left + HS_width;
parameter HS_right = HS_video + 16;
parameter HS_total = 800;

parameter VS_sync = 2;
parameter VS_top = VS_sync + 25 + 8;
parameter VS_height = 480;
parameter VS_video = VS_top + VS_height;
parameter VS_bottom = VS_video + 10;
parameter VS_total = 525;
