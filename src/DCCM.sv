`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MERL
// Engineer: 
// 
// Create Date: 12/21/2019 09:46:29 AM
// Design Name: BSV32I_SSC
// Module Name: Memory
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

module DCCM#(
parameter DataWidth=32,
parameter AddrWidth=15
)
(
    input brq_clk,
    input [2:0]byte_enable,
    input [AddrWidth-1:0] address,
    input [DataWidth-1:0] data_in, 
    input write_enable,read_enable, 
    output logic [DataWidth-1:0] data_out
);

localparam DEPTH = 2**AddrWidth;

logic [7:0]storing_byte;
logic [15:0]storing_half_byte;

assign storing_byte = data_in[7:0];
assign storing_half_byte = data_in[15:0];

/////////////////////////////////////////
bit [DataWidth-1:0]memory[0:DEPTH-1];//    MEMORY
/////////////////////////////////////////
//int i;
//initial begin
//    memory = 1023'd0; 
//end

reg [DataWidth-1:0] memory_in = 32'd0; 
////////////////sb///////////////////
always @(*) begin 
    memory_in = memory[address];
     if (byte_enable == 3'b011)
          memory_in[31:24] <= storing_byte;
else if (byte_enable == 3'b010)
          memory_in[23:16] <= storing_byte;
else if (byte_enable == 3'b001)
          memory_in[15:8] <= storing_byte;
else if (byte_enable == 3'b000)
          memory_in[7:0] <= storing_byte;
end
/////////////////sh//////////////////////
always @(*) begin 
    memory_in = memory[address];
     if (byte_enable == 3'b100)
          memory_in[31:16] <= storing_half_byte;
else if (byte_enable == 3'b101)
          memory_in[15:0] <= storing_half_byte;
end
/////////////////sw//////////////////////
always @(*) begin 
    if (byte_enable == 3'b110)
         memory_in <= data_in;
end
/////////////////////////////////////////MEMORY/////////////////////////////////
always @(posedge brq_clk) begin 
    if (write_enable)
        memory[address] <= memory_in;
end
always@(*) begin
if (read_enable)
  data_out <=  memory[address];
end
endmodule : DCCM