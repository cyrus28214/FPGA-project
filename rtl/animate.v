module animate (
    input wire swap,
    input wire [15:0] tile_id,
    output reg [15:0] tile_id_out
);
  `include "./parameters/resources_params.v"

  wire is_animate = (tile_id >= RS_slime_0 && tile_id <= RS_knight_7);

  always @* begin
    if (is_animate && swap) tile_id_out <= tile_id + 1;
    else tile_id_out <= tile_id;
  end

endmodule