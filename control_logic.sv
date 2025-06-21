\m5_TLV_version 1d: tl-x.org
\m5
   / A competition template for:
   / The First Annual Makerchip ASIC Design Showdown, Summer 2025, Space Battle

   use(m5-1.0)

   var(viz_mode, devel)

\SV
   m4_include_lib(https://raw.githubusercontent.com/rweda/showdown-2025-space-battle/main/showdown_lib.tlv)

   module team_amitops2103 (
      input logic clk, input logic reset,
      input logic signed [7:0] x [m5_SHIP_RANGE], input logic signed [7:0] y [m5_SHIP_RANGE],
      input logic [7:0] energy [m5_SHIP_RANGE],
      input logic [m5_SHIP_RANGE] destroyed,
      input logic signed [7:0] enemy_x_p [m5_SHIP_RANGE], input logic signed [7:0] enemy_y_p [m5_SHIP_RANGE],
      input logic [m5_SHIP_RANGE] enemy_cloaked,
      input logic [m5_SHIP_RANGE] enemy_destroyed,

      output logic signed [3:0] x_a [m5_SHIP_RANGE], output logic signed [3:0] y_a [m5_SHIP_RANGE],
      output logic [m5_SHIP_RANGE] attempt_fire, output logic [m5_SHIP_RANGE] attempt_shield,
      output logic [m5_SHIP_RANGE] attempt_cloak,
      output logic [1:0] fire_dir [m5_SHIP_RANGE]
   );

   localparam signed [7:0] max_x = m5_BOARD_WIDTH/2 - m5_HITBOX_RADIUS;
   localparam signed [7:0] min_x = -m5_BOARD_WIDTH/2 + m5_HITBOX_RADIUS;
   localparam signed [7:0] max_y = m5_BOARD_HEIGHT/2 - m5_HITBOX_RADIUS;
   localparam signed [7:0] min_y = -m5_BOARD_HEIGHT/2 + m5_HITBOX_RADIUS;

   logic signed [7:0] prev_enemy_x[3];
   logic signed [7:0] prev_enemy_y[3];

   always_ff @(posedge clk) begin
      for (int i = 0; i < 3; i++) begin
         if (!enemy_cloaked[i] && !enemy_destroyed[i]) begin
            prev_enemy_x[i] <= enemy_x_p[i];
            prev_enemy_y[i] <= enemy_y_p[i];
         end
      end
   end

   for (genvar ship = 0; ship < 3; ship++) begin
      assign x_a[ship] = 0;
      assign y_a[ship] = 0;
      assign attempt_fire[ship] = 0;
      assign attempt_shield[ship] = 0;
      assign attempt_cloak[ship] = 0;
      assign fire_dir[ship] = 2'd0;

      if (!destroyed[ship]) begin
         // OFFENSIVE STRATEGY: Predictive Firing
         for (int e = 0; e < 3; e++) begin
            if (!enemy_destroyed[e] && !enemy_cloaked[e]) begin
               logic signed [7:0] vx = enemy_x_p[e] - prev_enemy_x[e];
               logic signed [7:0] vy = enemy_y_p[e] - prev_enemy_y[e];
               logic signed [7:0] pred_x = enemy_x_p[e] + vx;
               logic signed [7:0] pred_y = enemy_y_p[e] + vy;

               if (pred_x == x[ship]) begin
                  assign fire_dir[ship] = (pred_y > y[ship]) ? 3 : 1;
                  assign attempt_fire[ship] = (energy[ship] > 40);
               end else if (pred_y == y[ship]) begin
                  assign fire_dir[ship] = (pred_x > x[ship]) ? 0 : 2;
                  assign attempt_fire[ship] = (energy[ship] > 40);
               end
            end
         end

         // DEFENSIVE STRATEGY
         if (energy[ship] <= 40 && energy[ship] > 20) begin
            assign attempt_shield[ship] = 1;
            assign attempt_cloak[ship] = 1;
         end

         // MANEUVER STRATEGY: Avoid boundaries
         if (energy[ship] <= 20) begin
            if (x[ship] < min_x + 4) assign x_a[ship] = 2;
            else if (x[ship] > max_x - 4) assign x_a[ship] = -2;

            if (y[ship] < min_y + 4) assign y_a[ship] = 2;
            else if (y[ship] > max_y - 4) assign y_a[ship] = -2;
         end
      end
   end

   endmodule

\TLV team_amitops2103_viz(/_top, _team_num)
   m5+io_viz(/_top, _team_num)
   \viz_js
      m5_DefaultTeamVizBoxAndWhere()
      render() {
         const destroyed = (this.sigVal("team_amitops2103.destroyed").asInt() >> this.getIndex("ship")) & 1;
         return [
            new fabric.Text(destroyed ? "I’m dead! ☹️" : "I’m alive! 😊", {
               left: 10, top: 50, originY: "center", fill: "black", fontSize: 10,
            })
         ];
      },

\TLV team_amitops2103(/_top)
   m5+verilog_wrapper(/_top, amitops2103)

\SV
   m5_makerchip_module

\TLV
   m5_team(amitops2103, Verilog Space Commander)
   m5_team(demo1, Test 1)
   m5+showdown(/top, /secret)
   *passed = /secret$passed || *cyc_cnt > 100;
   *failed = /secret$failed;
\SV
endmodule

