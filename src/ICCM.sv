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
parameter AddrWidth=15
)(
    input brq_clk,
    input [AddrWidth-1:0] address, 
    input i_write,
    input i_read,
    input [DataWidth-1:0] i_data,
    output logic [DataWidth-1:0] readData    
    );

    localparam DEPTH = 2**AddrWidth;
    logic [DataWidth-1:0] memory_array [0:DEPTH-1];

    initial begin
    
       $readmemh("hex_memory_file.mem",memory_array);

    //memory_array[0]  = 32'h00500293;
    //memory_array[1]  = 32'h00502A23;
    //memory_array[2]  = 32'h005282B3;
    //memory_array[3]  = 32'h01402283;
 
   // memory_array[0]  = 32'h0C800213;
   // memory_array[1]  = 32'h00420233;
   // memory_array[2]  = 32'h003AB2B7;
   // memory_array[3]  = 32'h00021397;
   // memory_array[4]  = 32'h00402423;
   // memory_array[5]  = 32'h00000033;
   // memory_array[6]  = 32'h00802403;


//Fibonacci Series
/*
 memory_array[0]  = 32'h01100F13;
 memory_array[1]  = 32'h00000E33;
 memory_array[2]  = 32'h000003B3;
 memory_array[3]  = 32'h00000333;
 memory_array[4]  = 32'h00100313;
 memory_array[5]  = 32'h000382B3;
 memory_array[6]  = 32'h001E0E13;
 memory_array[7]  = 32'h006283B3;
 memory_array[8]  = 32'hFFCF02E3;   
 memory_array[9]  = 32'h001E7E93;   // main instruction
 memory_array[10] = 32'hFE0E86E3;
 memory_array[11] = 32'h00038333;
 memory_array[12] = 32'hFE9FF0EF;
*/

 end    
    
 always @(posedge brq_clk) begin
     if(i_write) begin
         memory_array[address] <= i_data;
     end
end
 always @(*) begin
     if(i_read) 
         readData <= memory_array[address];
end     
endmodule: ICCM
