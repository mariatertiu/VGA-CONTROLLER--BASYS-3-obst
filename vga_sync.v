`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2025 10:26:22
// Design Name: 
// Module Name: vga_sync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_sync(
  input               clk_148Mhz  , // ceas de 148.5 MHz pentru Full HD
  input               reset       , // reset asincron, activ pe 1
  input signed [11:0] x_pos       , // coordonata X a centrului cercului
  input signed [11:0] y_pos       , // coordonata Y a centrului cercului
  input        [10:0] x_obs1      , // coordonata X a obstacolului 1
  input        [10:0] x_obs2      , // coordonata X a obstacolului 2
  input        [10:0] x_obs3      , // coordonata X a obstacolului 3
  output              h_sync      , // semnal de sincronizare orizontală
  output              v_sync      , // semnal de sincronizare verticală
  output reg   [3:0]  red         , // componenta roșie a pixelului
  output reg   [3:0]  green       , // componenta verde a pixelului
  output reg   [3:0]  blue        , // componenta albastră a pixelului
  output signed[11:0] pixel_x     , // coordonata X curentă a pixelului
  output signed[11:0] pixel_y       // coordonata Y curentă a pixelului
);
   
//parametrii orizontali
localparam HV  = 1920 ;  //horizontal visible (nr pixeli vizibili pe o linie)
localparam HFP =   88 ;  //horizontal front porch 
localparam HSP =   44 ;  //horizontal sync pulse (pt a stii cand s a terminat o linie)
localparam HBP =  148 ;  //horizontal back porch
localparam H_max     = HV + HFP + HSP + HBP-1; //2199 (nr pixeli pe o linie)


//parametrii verticali
localparam VV  = 1080 ;  //vertical visible area - zona vizibilă (1080 linii pe ecran)
localparam VFP =    4 ;  //vertical front porch  - pauză după imagine, înainte de sincronizare
localparam VSP =    5 ;  //vertical sync pulse   - durata impulsului de sincronizare verticală
localparam VBP =   36 ;  //vertical back porch   - pauză după sincronizare, înainte de imagine
localparam V_max = VV + VFP + VSP + VBP-1;  //1124 

//CERC
localparam RAZA = 60; // raza cercului desenat
//OBSTACOL
localparam GAURA1_START = 100, GAURA1_END = 300;
localparam GAURA2_START = 400, GAURA2_END = 600;
localparam GAURA3_START = 700, GAURA3_END = 900;
localparam LATIME_OBSTACOL = 50;

//registrii
reg [11:0] h_count; //contor creste de la 0 la h_max
reg [11:0] v_count; //contor creste de la 0 la v_max

//semnale de sincronizare
assign h_sync = (h_count >= HV + HFP) & (h_count < HV + HFP + HSP);  //orizontala
assign v_sync = (v_count >= VV + VFP) & ( v_count < VV + VFP + VSP); //verticala


//CONTOR ORIZONTAL
always @(posedge  clk_148Mhz or posedge reset) begin
    if (reset)
        h_count <= 0; 
    else if (h_count == H_max)  //h_count ajunge la sf liniei
        h_count <= 0;           //se reseteaza pentru a incepe o linie noua
    else
        h_count <= h_count + 1; 
end

// CONTOR VERTICAL
always @(posedge  clk_148Mhz or posedge reset) begin
    if (reset)
        v_count <= 0; 
    else if (h_count == H_max) begin //daca s-a terminat o linie
        if (v_count == V_max)        // si v_count a ajuns la sf cadrului
            v_count <= 0;            // se reseteaza pt a incepe un nou cadru
        else
            v_count <= v_count + 1;  // trecem la linia următoare
    end
end

// zona activă: 1920x1080
assign video_on = (h_count < HV) && (v_count < VV);

//coordonatele  pixelului curent
assign pixel_x = h_count;  // pixel_x = poziția orizontală actuală
assign pixel_y = v_count;  // pixel_y = poziția verticală actuală




//distanța pătratica față de centrul cercului
// dist_sq = (x - x₀)² + (y - y₀)²
wire [23:0] dist_sq;
assign dist_sq = (pixel_x - x_pos) * (pixel_x - x_pos) +
                 (pixel_y - y_pos) * (pixel_y - y_pos);

wire cerc_on;
assign cerc_on = (dist_sq <= RAZA * RAZA); //det daca pixelul curent se afla in interiorul cercului 
//Dacă distanța la centru este mai mică sau egală decât raza > desenăm cercul


//obstacole
wire obstacol1 = (pixel_x >= x_obs1 && pixel_x < x_obs1 + LATIME_OBSTACOL) &&
                 (pixel_y < GAURA1_START || pixel_y > GAURA1_END);

wire obstacol2 = (pixel_x >= x_obs2 && pixel_x < x_obs2 + LATIME_OBSTACOL) &&
                 (pixel_y < GAURA2_START || pixel_y > GAURA2_END);

wire obstacol3 = (pixel_x >= x_obs3 && pixel_x < x_obs3 + LATIME_OBSTACOL) &&
                 (pixel_y < GAURA3_START || pixel_y > GAURA3_END);





// afisare
  always @(posedge clk_148Mhz) begin
    if (video_on) begin
      if (cerc_on) begin
        // CERC VERDE
        red   <= 4'b0000;
        green <= 4'b1111;
        blue  <= 4'b0000;
      end else if (obstacol1 || obstacol2 || obstacol3) begin
        // OBSTACOL ROȘU
        red   <= 4'b1111;
        green <= 4'b0000;
        blue  <= 4'b0000;
      end else begin
        // FUNDAL NEGRU
        red   <= 4'b0000;
        green <= 4'b0000;
        blue  <= 4'b0000;
      end
    end else begin
      // ÎN AFARA ZONEI VIZIBILE
      red   <= 4'b0000;
      green <= 4'b0000;
      blue  <= 4'b0000;
    end
  end


endmodule

