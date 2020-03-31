`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MERL-UIT
// Engineer: 
// 
// Create Date: 03/11/2020 09:50:46 PM
// Design Name: Buraq-mini-RV32IM
// Module Name: Stall_Controller
// Project Name: BURAQ
// Target Devices: Arty A7 35T
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

module Stall_Controller
(
    input [1:0]idu_stall,
    input ldst_stall,    
    output logic stall  
);

always_comb begin
    stall = (ldst_stall | idu_stall[1] | idu_stall[0]) ? 1'b1 : 1'b0;
end

endmodule: Stall_Controller
