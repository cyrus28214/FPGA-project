localparam HS_sync = 96;
localparam HS_left = HS_sync + 40 + 8;
localparam HS_video = HS_left + 640;
localparam HS_right = HS_video + 16;
localparam HS_total = 800;

localparam VS_sync = 2;
localparam VS_top = VS_sync + 25 + 8;
localparam VS_video = VS_top + 480;
localparam VS_bottom = VS_video + 10;
localparam VS_total = 525;
