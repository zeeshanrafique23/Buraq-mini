`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MERL
// Engineer: 
// 
// Create Date: 12/19/2019 05:32:01 PM
// Design Name: BSV32I_SSC
// Module Name: control_unit
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


module Control_Unit (
    input [6:0] opcode,
    output logic branch_op,memRead,memtoReg,memWrite,regWriteEn,operand_B_sel,
    output logic [1:0] next_PC_sel,operand_A_sel, 
    output logic [2:0] ALUOp,
    output logic [1:0] extend_sel
);
   
    localparam      R_TYPE  = 7'b0110011, 
                    I_TYPE  = 7'b0010011, 
                    STORE   = 7'b0100011,
                    LOAD    = 7'b0000011,
                    BRANCH  = 7'b1100011,
                    JALR    = 7'b1100111,
                    JAL     = 7'b1101111,
                    AUIPC   = 7'b0010111,
                    LUI     = 7'b0110111;
                   // FENCES  = 7'b0001111,
                   // SYSCALL = 7'b1110011;

    assign regWriteEn    = ((opcode == R_TYPE) | (opcode == I_TYPE) | (opcode == LOAD)
                            | (opcode == JALR) | (opcode == JAL) | (opcode == AUIPC) 
                            | (opcode == LUI))? 1'b1 : 1'b0; 
    assign memWrite      = (opcode == STORE)?   1'b1 : 1'b0; 
    assign branch_op     = (opcode == BRANCH)?  1'b1 : 1'b0; 
    assign memRead       = (opcode == LOAD)?    1'b1 : 1'b0; 
    assign memtoReg      = (opcode == LOAD)?    1'b1 : 1'b0; 

    assign ALUOp         = (opcode == R_TYPE)?  3'b000 : 
                           (opcode == I_TYPE)?  3'b001 :
                           (opcode == STORE)?   3'b101 :   
                           (opcode == LOAD)?    3'b100 : 
                           (opcode == BRANCH)?  3'b010 : 
                           ((opcode == JALR)  | (opcode == JAL))? 3'b011 :
                           ((opcode == AUIPC) | (opcode == LUI))? 3'b110 : 3'b000; 
    
    assign operand_A_sel = (opcode == AUIPC)?  2'b01 : 
                           (opcode == LUI)?    2'b11 : 
                           ((opcode == JALR)  | (opcode == JAL))?  2'b10 : 2'b00; 
                           
    assign operand_B_sel = ((opcode == I_TYPE) | (opcode == STORE)| 
                           (opcode == LOAD) | (opcode == AUIPC) | | 
			   (opcode == JALR) | 
                           (opcode == LUI))? 1'b1 : 1'b0; 

    assign extend_sel    = ((opcode == I_TYPE)  | (opcode == JALR) | (opcode == LOAD))?  2'b00 : 
                           (opcode == STORE)?   2'b01  : 
                           ((opcode == AUIPC) | (opcode == LUI))? 2'b10 : 2'b00;

    assign next_PC_sel   =(opcode == BRANCH)?  2'b01  : 
                           (opcode == JAL)?     2'b10 : 
                           (opcode == JALR)?    2'b11 : 2'b00; 
                                                      
endmodule:control_unit