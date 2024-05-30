//this module is a simple top module for testing render_tile

`include "./render_tile.v"
`include "./pbdebounce.v"
`include "./render_pixel.v"
module render_pixel_top (
    input wire clk,  //100MHz
    input wire RSTN,
    input wire [3:0] BTN_Y,
    input wire [15:0] switch,
    output wire BTN_X4,
    output wire vga_hs,
    output wire vga_vs,
    output wire [3:0] vga_red,
    output wire [3:0] vga_green,
    output wire [3:0] vga_blue
);


  //cnt
  reg [31:0] cnt;
  always @(posedge clk or negedge RSTN) begin
    if (!RSTN) begin
      cnt <= 0;
    end else begin
      cnt <= cnt + 1;
    end
  end

  //button
  assign BTN_X4 = 0;
  wire [3:0] btn_dbc;

  genvar i;
  generate
    for (i = 0; i < 4; i = i + 1) begin
      pbdebounce u_pbdebounce (
          .clk   (cnt[17]),
          .button(BTN_Y[i]),
          .pbreg (btn_dbc[i])
      );
    end
  endgenerate

  //vga clock
  wire vga_clk;

  clk_div_vga clk_div_vga_inst (
      .clk_in (clk),
      .clk_out(vga_clk)
  );

  //pos
   reg [9:0] pos_x;
   reg [9:0] pos_y;
   always @(negedge RSTN or posedge cnt[17]) begin
     if (!RSTN) begin
       pos_x <= 10'd320;
       pos_y <= 10'd240;
     end else if (btn_dbc[0]) begin
       pos_x <= pos_x - 1;
       //    else begin
       //      if (btn_dbc[0] || btn_dbc[1]) begin
       //        pos_x <= btn_dbc[0] ? pos_x - 10'd1 : pos_x + 10'd1;
       //      end
       //      if (btn_dbc[2] || btn_dbc[3]) begin
       //        pos_y <= btn_dbc[2] ? pos_y - 10'd1 : pos_y + 10'd1;
       //      end
       //    end
     end
   end
//  wire [9:0] pos_x = switch[0] ? 100 : 300;
//  wire [9:0] pos_y = switch[1] ? 100 : 300;

  // render_tile

  // wire                                    finish;
  // wire                             [18:0] dst_addr;
  // wire                             [15:0] dst_data;
  // wire                                    dst_wr;
  // wire tile_rstn = RSTN & !finish;

  // render_tile u_render_tile (
  //     .clk      (clk),
  //     .rstn     (tile_rstn),
  //     .tile_addr(0),
  //     .top      (pos_y),
  //     .left     (pos_x),
  //     .finish   (finish),
  //     .dst_addr (dst_addr),
  //     .dst_data (dst_data),
  //     .dst_wr   (dst_wr)
  // );

  //vga
  wire [11:0] vga_rgb;
  wire [18:0] mem_addr;
  wire [15:0] mem_data;
  vga_mem vga_mem_inst (
      .clk(vga_clk),
      .rstn(RSTN),
      .mem_data(mem_data),
      .mem_addr(mem_addr),
      .mem_rd(),
      .hs(vga_hs),
      .vs(vga_vs),
      .rgb(vga_rgb)
  );
  assign vga_red   = vga_rgb[11:8];
  assign vga_green = vga_rgb[7:4];
  assign vga_blue  = vga_rgb[3:0];

  // outports wire
  wire [18:0] dst_addr;
  wire [15:0] dst_data;
  wire        dst_wr;
  wire [15:0] color;

  render_pixel u_render_pixel (
      .pos_x   (pos_x + cnt[4:0]),
      .pos_y   (pos_y + cnt[9:5]),
      .color   (color),
      .dst_addr(dst_addr),
      .dst_data(dst_data),
      .dst_wr  (dst_wr)
  );

  bROM_tile bROM_tile_inst (
      .clka (clk),
      .addra(cnt[9:0]),
      .douta(color)
  );


  //ram for vga
  bRAM ram_inst (
      .clka (clk),
      .addra(dst_addr),
      .wea  (dst_wr),
      .dina (dst_data),
      .douta(),

      .clkb (vga_clk),
      .addrb(mem_addr),
      .web  (0),
      .dinb (0),
      .doutb(mem_data)
  );


endmodule
