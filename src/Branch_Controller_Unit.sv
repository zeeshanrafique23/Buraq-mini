`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MERL-UIT
// Engineer: 
// 
// Create Date: 01/05/2020 03:26:54 PM
// Design Name: Buraq-mini-RV32IM
// Module Name: Branch_Controller_Unit
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

module Branch_Controller_Unit#(parameter DataWidth=32)
(
    input [2:0]func3,
    input [DataWidth-1:0]SRC_1,
    input [DataWidth-1:0]SRC_2,
    
    output logic Branch
);

always_comb begin
    if(func3 == 3'b000) 
       if (SRC_1 == SRC_2)                                                  //BEQ
          Branch = 1'b1;
       else
          Branch = 1'b0;
    else
    if((func3 == 3'b001) && ($signed(SRC_1) != $signed(SRC_2)))          //BNE 
        Branch = 1'b1;
    else
    if((func3 == 3'b100) && ($signed(SRC_1) <  $signed(SRC_2)))          //BLT
        Branch = 1'b1;
    else
    if((func3 == 3'b101) && ($signed(SRC_1) >= $signed(SRC_2)))          //BGE
        Branch = 1'b1;
    else
    if((func3 == 3'b110) && ($unsigned(SRC_1) <  $unsigned(SRC_2)))      //BLTU
        Branch =1'b1;
    else
    if((func3 == 3'b111) && ($unsigned(SRC_1) >= $unsigned(SRC_2)))      //BGEU
        Branch =1'b1;
    else
        Branch =1'b0;
end

endmodule: Branch_Controller_Unit