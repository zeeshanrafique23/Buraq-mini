`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MERL-UIT
// Engineer: 
// 
// Create Date: 12/22/2019 01:37:48 AM
// Design Name: Buraq-mini-RV32IM
// Module Name: Buraq_Top_RV32IM
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

module Buraq_Top_RV32IM #(
parameter DataWidth=32,
parameter AddrWidth=15,
parameter RegAddrWidth=5
)
(   
    input  brq_clk,
    input  brq_rst,
    output logic [DataWidth-1:0]Reg_Out
);

logic [DataWidth-1:0]Ins_mem_out;
logic [DataWidth-1:0]D_mem_out;
logic [DataWidth-1:0]Ins_mem_data_in;
logic [DataWidth-1:0]D_mem_data_in;
logic [AddrWidth-1:0]Ins_mem_addr_in;
logic [AddrWidth-1:0]D_mem_addr_in;
logic [2:0]byte_en;
logic D_mem_readEn;
logic D_mem_writeEn;

Buraq_RV32IM#(DataWidth,AddrWidth,RegAddrWidth)Core
(
        .brq_clk(brq_clk),
        .brq_rst(brq_rst),
        .inst_mem_data(Ins_mem_out),
        .Data_mem_dataOut(D_mem_out),
        //OUTPUTS//
        .ldst_byte_en(byte_en),
        .Data_mem_dataIn(D_mem_data_in),
        .inst_mem_address(Ins_mem_addr_in),
        .Data_mem_address(D_mem_addr_in),
        .Data_mem_read_en(D_mem_readEn),
        .Data_mem_write_en(D_mem_writeEn),
        .reg_out(Reg_Out)
);

DCCM#(DataWidth,AddrWidth)DataMemory
(
        .brq_clk(brq_clk),
        .byte_enable(byte_en),
        .read_enable(D_mem_readEn),        
        .write_enable(D_mem_writeEn),       
        .data_in(D_mem_data_in),
        .address(D_mem_addr_in),
        //OUTPUT//
        .data_out(D_mem_out)
);

ICCM#(DataWidth,AddrWidth)InstructionMemory
(
    .brq_clk(brq_clk),
    .address(Ins_mem_addr_in), 
    .i_write(1'b0),
    .i_read(1'b1),
    .i_data(Ins_mem_data_in),
    //OUTPUT//
    .readData(Ins_mem_out)    
);

<<<<<<< HEAD
endmodule: Buraq_Top_RV32IM
=======
endmodule: Buraq_Top_RV32IM
>>>>>>> 8d2c8cf1fff13e00f915160ae8dc0100200f9a06
