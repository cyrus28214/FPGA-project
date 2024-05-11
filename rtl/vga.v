module vga_ctrl(clk, hs, vs, r, g, b);
    input            clk; //25.172MHz@60Hz
    output reg       hs, vs;
    output reg [3:0] r, g, b;

    //Horizontal timing
    parameter HS_sync  = 96;     //Sync
    parameter HS_left  = 48;     //Back Porch + Left Border
    parameter HS_video = 640;    //Video
    parameter HS_right = 16;     //Front Porch + Right Border
    parameter HS_total = 800;    //Total

    //Vertical timing
    parameter VS_sync  = 2;      //Sync
    parameter VS_top   = 33;     //Back Porch + Top Border
    parameter VS_video = 480;    //Video
    parameter VS_bottom= 10;     //Front Porch + Bottom Border
    parameter VS_total = 525;    //Total

    reg [9:0] hcnt,
              vcnt;

    always @ (posedge clk) begin

        hcnt <= (hcnt == HS_total - 1) ? 0 : hcnt + 1;
        vcnt <= (vcnt == VS_total - 1) ? 0 : vcnt + 1;

        hs <= (hcnt < VS_sync) ? 1 : 0;
        vs <= (vcnt < HS_sync) ? 1 : 0;

        r <= 4'b1111;
        g <= 4'b0000;
        b <= 4'b0000;
    end

endmodule