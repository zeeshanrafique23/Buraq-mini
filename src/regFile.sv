`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MERL
// Engineer: 
// 
// Create Date: 12/20/2019 05:59:22 PM
// Design Name: BSV32I_SSC
// Module Name: regFile
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


module RegFile#(
parameter DataWidth=32,
parameter Registers=32,
parameter AddrRegWidth=5
)
(
    input brq_clk,
    input brq_rst,
    input writeEn,
    input [AddrRegWidth-1:0]source1,
    input [AddrRegWidth-1:0]source2,
    input [AddrRegWidth-1:0]writeDataSel,
    input [DataWidth-1:0]writeData,
    output logic [DataWidth-1:0]readData1,
    output logic [DataWidth-1:0]readData2 ,
    output logic [DataWidth-1:0]Reg_Out
);

localparam number_of_registers = 2**AddrRegWidth;

logic [DataWidth-1:0]regFile [0:(number_of_registers)-1];

integer i;
initial begin
  for (i=0;i<(number_of_registers);i=i+1)begin
    regFile[i]<=0;
  end
  regFile[2]<=32'h00000200;
end

always @ (posedge brq_clk)begin
    if (brq_rst==1'b1) begin
        for (i=0;i<(number_of_registers);i=i+1)
            regFile[i]<=0;
        end
    else if (brq_rst==1'b0 && writeEn==1'b1)begin
            if (writeDataSel==5'd0)
                regFile[0]<=32'h00000000;
            else
                regFile[writeDataSel]<=writeData;       
        end
end

assign readData1 = regFile[source1];
assign readData2 = regFile[source2];

assign Reg_Out   = regFile[15];
endmodule:regFile