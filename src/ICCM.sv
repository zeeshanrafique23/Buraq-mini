`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MERL-UIT
// Engineer: 
// 
// Create Date: 12/28/2019 10:43:10 AM
// Design Name: Buraq-mini-RV32IM
// Module Name: ICCM
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

module ICCM#(
parameter DataWidth=32,
parameter HalfWord =16,
parameter AddrWidth=15
)(
    input brq_clk,
    input [AddrWidth-1:0] address, 
    input i_write,
    input i_read,
    input [DataWidth-1:0] i_data,
    output logic [HalfWord-1:0] readData_lsb,
    output logic [HalfWord-1:0] readData_msb    
    );

    localparam DEPTH = 2**AddrWidth;
    logic [HalfWord-1:0] memory [0:DEPTH-1];

    initial begin
    
       $readmemh("C:/Users/merllab/Desktop/Buraq-RV32IM-systemverilog/src/hex_memory_file.mem",memory);
//Fibonacci Series
/*
 memory[0]  = 32'h01100F13;
 memory[1]  = 32'h00000E33;
 memory[2]  = 32'h000003B3;
 memory[3]  = 32'h00000333;
 memory[4]  = 32'h00100313;
 memory[5]  = 32'h000382B3;
 memory[6]  = 32'h001E0E13;
 memory[7]  = 32'h006283B3;
 memory[8]  = 32'hFFCF02E3;   
 memory[9]  = 32'h001E7E93;   // main instruction
 memory[10] = 32'hFE0E86E3;
 memory[11] = 32'h00038333;
 memory[12] = 32'hFE9FF0EF;
*/

 end    
    
 always @(posedge brq_clk) begin
     if(i_write) begin
         memory[address] <= i_data;
     end
end
 always @(*) begin
     if(i_read) 
         readData_lsb <= memory[address];
         readData_msb <= memory[address+1];
end     
endmodule: ICCM
