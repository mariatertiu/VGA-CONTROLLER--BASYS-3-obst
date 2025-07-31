`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2025 11:54:43
// Design Name: 
// Module Name: detector_front
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


module detector_front(
    input      clk_148Mhz   ,
    input      reset        , //reset asincron, activ high
    input      btn          , //buton de intrare
    output reg btn_apasat     // semnal 1 cand se apasa butonul
);

reg btn_prev;  //memoreaza starea anterioara a btn

// actualizare btn_prev 
always @(posedge clk_148Mhz or posedge reset) begin
    if (reset)
        btn_prev <= 0;        //presupunem ca nu era apasat inainte
    else
        btn_prev <= btn;      //salvam val curenta pt pasul urm
end

always @(posedge clk_148Mhz or posedge reset) begin
    if (reset)                           //reset activ
        btn_apasat <= 0;                 //se reseteaza imediat valoarea
    else if (btn == 1 && btn_prev == 0)  //daca btn apasat si cel anterior nu
        btn_apasat <= 1;                 //=1, s a apasat butonul
        else
        btn_apasat <=0;                  //=0, nu s a apasat inca
end

endmodule


