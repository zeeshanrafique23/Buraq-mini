`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MERL-UIT
// Engineer: 
// 
// Create Date: 12/20/2019 06:32:15 PM
// Design Name: Buraq-mini-RV32IM
// Module Name: Imm-Gen
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

module Imm_Gen#(
parameter DataWidth=32
)
(
    input [DataWidth-1:0]pc,
    input [(DataWidth-1)-7:0]instruction,
    output logic [DataWidth-1:0]i_type,
    output logic [DataWidth-1:0]u_type,
    output logic [DataWidth-1:0]s_type,
    output logic [DataWidth-1:0]sb_type,
    output logic [DataWidth-1:0]uj_type
);
logic [11:0] I_type;
logic [19:0] U_type;
logic [11:0] S_type;
logic [12:0] SB_type;
logic [20:0] UJ_type;

always_comb begin
    I_type  = instruction[24:13];
    U_type  = instruction[24:5];
    S_type  = {instruction[24:18],instruction[4:0]};
    SB_type = {instruction[24],instruction[0],instruction[23:18],instruction[4:1],1'b0};
    UJ_type = {instruction[24],instruction[12:5],instruction[13],instruction[23:14],1'b0};

    u_type  = {U_type ,12'b0 };
    i_type  = {I_type [11]  ? 20'hFFFFF : 20'd0,I_type };
    s_type  = {S_type [11]  ? 20'hFFFFF : 20'd0,S_type };
    sb_type = {SB_type[12]  ? 19'h7FFFF : 19'd0,SB_type} + pc;
    uj_type = {UJ_type[20]  ? 11'h7FF   : 11'd0,UJ_type} + pc;
end

endmodule:Imm_Gen