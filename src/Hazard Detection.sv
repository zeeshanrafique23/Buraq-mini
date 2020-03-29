`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/15/2020 11:07:56 AM
// Design Name: 
// Module Name: Hazard Detection
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


module Hazard_Detection
(   
    input clock,
    input [1:0]next_pc_select,
    output logic flush
);

always @ (posedge clock) begin
    if (next_pc_select!=2'b00)
        flush = 1'b1;
    else
        flush = 1'b0;
end 


endmodule
