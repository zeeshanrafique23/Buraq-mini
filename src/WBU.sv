`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MERL
// Engineer: 
// 
// Create Date: 12/21/2019 06:44:56 PM
// Design Name: BSV32I_SSC
// Module Name: WriteBack
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


module WBU#(
parameter DataWidth=32,
parameter RegAddrWidth=10
)
(
    input ldst_memtoreg,
    input [RegAddrWidth-1:0]ldst_addr_dst,
    input [DataWidth-1:0]ldst_alu_result,
    input [DataWidth-1:0]ldst_load_data,
    output logic [DataWidth-1:0]wbu_result,
    output logic [RegAddrWidth-1:0]wbu_addr_dst
);

always_comb begin
    if(ldst_memtoreg)
        wbu_result = ldst_load_data;
    else
        wbu_result = ldst_alu_result;
end

assign wbu_addr_dst = ldst_addr_dst;

endmodule:WBU
