`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MERL-UIT
// Engineer: 
// 
// Create Date: 03/28/2020 01:43:04 PM
// Design Name: Buraq-mini-RV32IM
// Module Name: Comp_Ins
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

module Comp_Ins #(DataWidth =32)
(
	input [15:0]inst_lsb,
	input [15:0]inst_msb,
        output logic i_type,
	output logic [31:0]instruction
);

logic ins_err;
logic [DataWidth-1:0]c_instruction;
logic [DataWidth-1:0]i_instruction;
logic c_type;

assign i_instruction = {inst_msb , inst_lsb};
assign c_type = (inst_lsb[1:0] == 2'b11) ? 1'b0 : 1'b1;
assign instruction =  c_type ? c_instruction : i_instruction;

buraq_rv32imc_expander c_expander(inst_lsb,i_type,ins_err,c_instruction);

endmodule: Comp_Ins