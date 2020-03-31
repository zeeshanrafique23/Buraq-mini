`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MERL-UIT
// Engineer: 
// 
// Create Date: 01/06/2020 01:30:03 PM
// Design Name: Buraq-mini-RV32IM
// Module Name: UnConditional_Forwarding
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

module UnConditional_Forwarding#
(
parameter DataWidth = 32, 
parameter RegAddrWidth = 5
)
(   
    input Reg_File_EN_Execute_stage,
    input Reg_File_EN_Memory_stage,
    input Reg_File_EN_WrBk_stage,
    input Mem_Read_EN_Execute_stage,
    input Mem_Read_EN_Memory_stage,
    input [RegAddrWidth-1:0]WriteBack_reg_Execute_stage,
    input [RegAddrWidth-1:0]WriteBack_reg_Memory_stage,
    input [RegAddrWidth-1:0]WriteBack_reg_WrBk_stage,
    input [RegAddrWidth-1:0]IF_ID_RS1,
    input [RegAddrWidth-1:0]IF_ID_RS2,
    
    output logic [3:0]Operand_A_control,
    output logic [3:0]Operand_B_control   
);

always_comb begin
    if ((WriteBack_reg_Execute_stage == IF_ID_RS1) && Reg_File_EN_Execute_stage == 1'b1 && IF_ID_RS1!= 5'b0)begin
        if (Mem_Read_EN_Execute_stage)
        	Operand_A_control = 4'b0011;
        else
                Operand_A_control = 4'b1000;
    end   
    else
    if((WriteBack_reg_Memory_stage == IF_ID_RS1) && Reg_File_EN_Memory_stage == 1'b1 && IF_ID_RS1!= 5'b0)begin
        if (Mem_Read_EN_Memory_stage)
        	Operand_A_control = 4'b0100;
        else
                Operand_A_control = 4'b0010;
    end 
    else
    if ((WriteBack_reg_WrBk_stage == IF_ID_RS1) && Reg_File_EN_WrBk_stage == 1'b1 && IF_ID_RS1!= 5'b0)
        Operand_A_control = 4'b0001;
    else
        Operand_A_control = 4'b0000;
end


always_comb begin
    if ((WriteBack_reg_Execute_stage == IF_ID_RS2) && Reg_File_EN_Execute_stage == 1'b1 && IF_ID_RS2!= 5'b0)begin
        if (Mem_Read_EN_Execute_stage)
        	Operand_B_control = 4'b0011;
        else
                Operand_B_control = 4'b1000;
    end   
    else
    if((WriteBack_reg_Memory_stage == IF_ID_RS2) && Reg_File_EN_Memory_stage == 1'b1 && IF_ID_RS2!= 5'b0)begin
        if (Mem_Read_EN_Memory_stage)
        	Operand_B_control = 4'b0100;
        else
                Operand_B_control = 4'b0010;
    end 
    else
    if ((WriteBack_reg_WrBk_stage == IF_ID_RS2) && Reg_File_EN_WrBk_stage == 1'b1 && IF_ID_RS2!= 5'b0)
        Operand_B_control = 4'b0001;
    else
        Operand_B_control = 4'b0000;
end

endmodule: UnConditional_Forwarding
