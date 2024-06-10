module enemy_attack (
    input wire [15:0] tile_id,
    output reg [15:0] attack
);
  `include "../parameters/resources_params.v"
  always @(*) begin
    case (tile_id)
      RS_slime_0: attack <= 1;
      RS_slime_1: attack <= 1;
      RS_slime_2: attack <= 2;
      RS_slime_3: attack <= 2;
      RS_slime_4: attack <= 3;
      RS_slime_5: attack <= 3;
      RS_slime_6: attack <= 4;
      RS_slime_7: attack <= 4;
      RS_bat_0: attack <= 2;
      RS_bat_1: attack <= 2;
      RS_bat_2: attack <= 3;
      RS_bat_3: attack <= 3;
      RS_bat_4: attack <= 4;
      RS_bat_5: attack <= 4;
      RS_bat_6: attack <= 5;
      RS_bat_7: attack <= 5;
      RS_skeleton_0: attack <= 3;
      RS_skeleton_1: attack <= 3;
      RS_skeleton_2: attack <= 4;
      RS_skeleton_3: attack <= 4;
      RS_skeleton_4: attack <= 5;
      RS_skeleton_5: attack <= 5;
      RS_skeleton_6: attack <= 6;
      RS_skeleton_7: attack <= 6;
      RS_mummy_0: attack <= 4;
      RS_mummy_1: attack <= 4;
      RS_mummy_2: attack <= 6;
      RS_mummy_3: attack <= 6;
      RS_mummy_4: attack <= 8;
      RS_mummy_5: attack <= 8;
      RS_mummy_6: attack <= 10;
      RS_mummy_7: attack <= 10;
      RS_wizard_0: attack <= 4;
      RS_wizard_1: attack <= 4;
      RS_wizard_2: attack <= 6;
      RS_wizard_3: attack <= 6;
      RS_wizard_4: attack <= 8;
      RS_wizard_5: attack <= 8;
      RS_wizard_6: attack <= 10;
      RS_wizard_7: attack <= 10;
      RS_knight_0: attack <= 4;
      RS_knight_1: attack <= 4;
      RS_knight_2: attack <= 6;
      RS_knight_3: attack <= 6;
      RS_knight_4: attack <= 8;
      RS_knight_5: attack <= 8;
      RS_knight_6: attack <= 10;
      RS_knight_7: attack <= 10;
      default: attack <= 0;
    endcase
  end


endmodule
