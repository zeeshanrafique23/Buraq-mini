`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MERL
// Engineer: 
// 
// Create Date: 12/20/2019 11:51:23 PM
// Design Name: BSV32I_SSC
// Module Name: ALU
// Project Name: BURAQ
// Target Devices: ATRY 7 A35 T
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

`define Multipilcation

module ALU#(parameter DataWidth=32)
(
    input [DataWidth-1:0]operand_A,
    input [DataWidth-1:0]operand_B,
    input [5:0]ALU_Control,
    output logic [DataWidth-1:0]ALU_result
    //output logic branch
);

//logic [1:0]branch_op;
logic mul,mulh;
logic [DataWidth-1:0]mul_lower;
logic [DataWidth-1:0]mul_upper;
logic [DataWidth-1:0]ALU_result_32;
logic [2*DataWidth-1:0]ALU_result_64;
logic [4:0]shamt;
assign shamt = operand_B[4:0];

always_comb begin 
   ALU_result_32 = 
            (ALU_Control == 6'b000_000)? operand_A + operand_B:                /* ADD, ADDI*/
            (ALU_Control == 6'b001_000)? operand_A - operand_B:                /* SUB */
            (ALU_Control == 6'b000_100)? operand_A ^ operand_B:                /* XOR, XORI*/
            (ALU_Control == 6'b000_110)? operand_A | operand_B:                /* OR, ORI */
            (ALU_Control == 6'b000_111)? operand_A & operand_B:                /* AND, ANDI */
            (ALU_Control == 6'b000_010)? operand_A < operand_B:                /* SLT, SLTI */
            (ALU_Control == 6'b000_011)? operand_A < operand_B:                /* SLTU, SLTIU */
            (ALU_Control == 6'b000_001)? operand_A << shamt:                   /* SLL, SLLI => 0's shifted in from right */
            (ALU_Control == 6'b000_101)? operand_A >> shamt:                   /* SRL, SRLI => 0's shifted in from left */
            (ALU_Control == 6'b001_101)? operand_A >> shamt:                   /* SRA, SRAI => sign bit shifted in from left */
            (ALU_Control == 6'b111_111)? operand_A:                            /* operand_A = PC+4 for JAL */
            (ALU_Control == 6'b010_000)? (operand_A == operand_B):             /* BEQ */
            (ALU_Control == 6'b010_001)? (operand_A != operand_B):             /* BNE */
            (ALU_Control == 6'b010_100)? (operand_A < operand_B):              /* BLT */
            (ALU_Control == 6'b010_101)? (operand_A >= operand_B):             /* BGE */
            (ALU_Control == 6'b010_110)? (operand_A < operand_B):              /* BLTU */
            (ALU_Control == 6'b010_111)? (operand_A >= operand_B): 0;          /* BGEU */

   ALU_result_64 = 
            (ALU_Control == 6'b011_000 | ALU_Control == 6'b011_001)? operand_A * operand_B:   /* MUL, MULH */
            (ALU_Control == 6'b011_010)? operand_A * $unsigned(operand_B):                    /* MULHSU */
            (ALU_Control == 6'b011_011)? $unsigned(operand_A) * $unsigned(operand_B):         /* MULHU */
            (ALU_Control == 6'b011_100)? operand_A / operand_B:                               /* DIV */
            (ALU_Control == 6'b011_101)? $unsigned(operand_A) / $unsigned(operand_B):         /* DIVU */
            (ALU_Control == 6'b011_110)? operand_A % operand_B:                               /* REM */
            (ALU_Control == 6'b011_111)? $unsigned(operand_A) % $unsigned(operand_B): 0;      /* REMU */
 
end

assign mul_lower = ALU_result_64[31:0];
assign mul_upper = ALU_result_64[63:32];

assign mul   = ((ALU_Control >= 6'd24 && ALU_Control <= 6'd30) || (ALU_Control == 6'd18)) ? 1'b1 : 1'b0;
assign mulh  = ( 6'd26>= ALU_Control >= 6'd25)? 1'b1 : 1'b0;
assign ALU_result = mul ? (mulh ? mul_upper : mul_lower) : ALU_result_32 ;

 //assign branch_op = ALU_Control[4:3]; 
 //assign branch = ((branch_op == 2'b10)&& (ALU_result == 1'b1))? 1'b1: 1'b0;    
  
endmodule:ALU