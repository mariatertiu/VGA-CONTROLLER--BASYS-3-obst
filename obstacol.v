`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2025 16:30:27
// Design Name: 
// Module Name: obstacol
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




// Modul care generează poziția X a unui obstacol vertical ce se deplasează de la dreapta la stânga
module obstacol #(
    parameter LUNGIME_ECRAN     = 1920, // rezoluția orizontală a ecranului
    parameter LATIME_OBSTACOL   = 50,   // lățimea obstacolului (fixă)
    parameter DELAY             = 0     // întârziere inițială (pentru a desincroniza obstacolele)
)(
    input        clk_148Mhz, // ceasul principal (148.5 MHz)
    input        reset     , // reset asincron, activ pe 1
    input        tick_obs  , // semnal lent (ex: 1 dată la 20 ms), controlează deplasarea
    output reg [10:0] x_obs  // poziția X curentă a obstacolului
);

  // VITEZA cu care se deplasează obstacolul 
  localparam VITEZA = 30;

  // La fiecare tick, obstacolul se deplasează spre stânga cu VITEZA
  // Când iese complet din ecran (x_obs = 0), reapare la dreapta

  always @(posedge clk_148Mhz or posedge reset) begin
    if (reset)
      // La reset, obstacolul pornește din afara ecranului (cu întârziere DELAY)
      x_obs <= LUNGIME_ECRAN + DELAY;
    else if (tick_obs) begin
      if (x_obs == 0)
        // Când iese complet din ecran, reapare din dreapta
        x_obs <= LUNGIME_ECRAN + DELAY;
      else
        // Altfel, se deplasează spre stânga
        x_obs <= x_obs - VITEZA;
    end
  end

endmodule


