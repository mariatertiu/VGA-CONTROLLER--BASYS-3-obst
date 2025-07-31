`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2025 12:01:38
// Design Name: 
// Module Name: controller_patrat
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


module controller_patrat(
    input      clk_148Mhz          ,
    input      reset               ,  // reset asincron, activ pe 1
    input      buton_apasatL       ,  // buton stânga
    input      buton_apasatR       ,  // buton dreapta
    input      buton_apasatU       ,  // buton sus
    input      buton_apasatD       ,  // buton jos
    output reg signed [11:0] x_pos ,  // poziția pe axa X a centrului cercului
    output reg signed [11:0] y_pos    // poziția pe axa Y a centrului cercului
   
);

  // dimensiunea unei mișcări
  localparam PAS = 20;
  localparam RAZA = 60;
  
always @(posedge clk_148Mhz or posedge reset )
  if (reset)begin
  x_pos <= 960;
  y_pos <= 540;
   end else  begin
// deplasare spre stânga, doar dacă nu iese în afara ecranului 
if (buton_apasatL && x_pos - PAS - RAZA > 0 )
    x_pos <= x_pos - PAS;
// deplasare spre dreapta, cu limită la marginea din dreapta
if (buton_apasatR && (x_pos + RAZA +PAS< 1919))
    x_pos <= x_pos + PAS;
//deplasare in sus, cu limita
if (buton_apasatU &&( y_pos - PAS - RAZA > 0))
    y_pos <= y_pos - PAS;
//deplasare in jos
if (buton_apasatD &&(y_pos + PAS + RAZA < 1079))
    y_pos <= y_pos + PAS;
end
  

endmodule
  


