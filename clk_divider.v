`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2025 16:39:06
// Design Name: 
// Module Name: clk_divider
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


module clk_divizor #(
    parameter MAX_COUNT = 148_500_000  // numărul de cicluri pentru un tick (ex: 1 secundă la 148 MHz)
)(
    input  clk_148Mhz  ,  // semnalul de ceas de 148 MHz
    input  reset       ,  // reset asincron, activ pe 1
    output reg tick       // semnal de "tic" generat o dată la MAX_COUNT
);

reg [31:0] contor; // contor pentru numărarea ciclurilor de ceas

// contor principal – numără până la MAX_COUNT
always @(posedge clk_148Mhz or posedge reset) begin
    if (reset)
        contor <= 0;                    // reset contor
    else if (contor == MAX_COUNT)
        contor <= 0;                    // reset după atingerea valorii maxime
    else
        contor <= contor + 1;          // incrementare
end

// generare semnal tick – activ 1 doar când contorul atinge MAX_COUNT
always @(posedge clk_148Mhz or posedge reset) begin
    if (reset)
        tick <= 0;                      // reset semnal tick
    else if (contor == MAX_COUNT)
        tick <= 1;                      // semnal tick activ pentru un singur ciclu
    else
        tick <= 0;                      // inactiv în rest
end

endmodule


