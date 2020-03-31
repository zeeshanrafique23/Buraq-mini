`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MERL-UIT
// Engineer: 
// 
// Create Date: 12/21/2019 01:07:46 AM
// Design Name: Buraq-mini-RV32IM
// Module Name: IEU
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

module IEU #(
parameter DataWidth=32,
parameter AddrWidth=10,
parameter RegAddrWidth=5
)
(	
    input  brq_clk,brq_rst,stall,
    input  ldst_regfile_en,
    input  [1:0]check_stall_In,
    input  [DataWidth-1:0]idu_store_data,
    input  [DataWidth-1:0]idu_data_1,
    input  [DataWidth-1:0]idu_data_2,
    input  [1:0]ieu_op_a_sel,
    input  ieu_op_b_sel,
    input  [DataWidth-1:0]ldst_mem_result,
    input  [2:0]idu_func3,
    input  [6:0]idu_func7,
    input  [2:0]idu_aluop,
    input  [DataWidth-1:0]ieu_pc,ieu_immediate,
    input  idu_memtoreg,idu_mem_wen,idu_mem_ren,idu_regfile_en,
    input  [RegAddrWidth-1:0]idu_addr_dst,
    input  [RegAddrWidth-1:0]ieu_src1_reg,
    input  [RegAddrWidth-1:0]ieu_src2_reg,
    input  [RegAddrWidth-1:0]wbu_addr_dst,
    input  [DataWidth-1:0]wbu_result,
    
    output logic [2:0]ieu_func3,
    output logic ieu_stall,
    output logic [1:0]check_stall_Out,
    output logic ieu_regfile_en,ieu_mem_ren,ieu_mem_wen,ieu_memtoreg,
    output logic [RegAddrWidth-1:0]ieu_addr_dst,
    output logic [DataWidth-1:0]ieu_alu_result,
    output logic [DataWidth-1:0]ieu_alu_result_dealy,
    output logic [DataWidth-1:0]ieu_mem_addr,
    output logic [DataWidth-1:0]ieu_store_data
);
logic mem_busy;
logic ldst_resume;
logic [2:0]op_A_sel;
logic [2:0]op_B_sel;
logic [DataWidth-1:0]SRC_A;
logic [DataWidth-1:0]SRC_B;
logic [DataWidth-1:0]SOURCE_A;
logic [DataWidth-1:0]SOURCE_B;
logic [5:0]ALU_MUX_CONTROL;
logic [AddrWidth-1:0]Mem_addr;

ALU #(DataWidth)alu
(
    .operand_A(SRC_A),  
    .operand_B(SRC_B),
    .ALU_Control(ALU_MUX_CONTROL),
    .ALU_result(ieu_alu_result)
);

ALU_Control aluControl
(
    .func3(idu_func3),
    .func7(idu_func7),
    .ALU_Operation(idu_aluop),
    .ALU_Control(ALU_MUX_CONTROL)
);

Forwarding_Unit#(DataWidth,RegAddrWidth) Forwarding_For_Data_Hazard
(   
     .Reg_File_EN_Memory_stage(ieu_regfile_en),  
     .Reg_File_EN_WrBk_stage(ldst_regfile_en),
     .Mem_Read_EN(ieu_mem_ren),
     .WriteBack_reg_Memory_stage(ieu_addr_dst),
     .WriteBack_reg_WrBk_stage(wbu_addr_dst),
     .EX_RS1(ieu_src1_reg),
     .EX_RS2(ieu_src2_reg),
     //OUTPUT//
     .Operand_A_control(op_A_sel),
     .Operand_B_control(op_B_sel)  
);

always_comb begin
    SRC_A = (ieu_op_a_sel==2'b11)? 32'b0:
            (ieu_op_a_sel==2'b01)? ieu_pc :
            (ieu_op_a_sel==2'b10)? ieu_pc + 32'd4 : 
            SOURCE_A;

    SRC_B = (ieu_op_b_sel==1'b1) ? ieu_immediate : SOURCE_B;          
end

always_comb begin
  SOURCE_A =  (op_A_sel == 3'b001) ? ieu_alu_result_dealy:
              (op_A_sel == 3'b100) ? wbu_result:
               idu_data_1;
  SOURCE_B =  (op_B_sel == 3'b001) ? ieu_alu_result_dealy:
              (op_B_sel == 3'b100) ? wbu_result:
               idu_data_2;
 ieu_stall =  (ldst_resume) ? 1'b0 :
              (op_A_sel[1]) ? 1'b1 : 1'b0;
 mem_busy  =  (op_A_sel[1]) ? 1'b1 : 1'b0;
end
////////////////////////////////////////////////////////////////////////////
always @(posedge brq_clk)begin
    if(brq_rst)begin
        ieu_regfile_en    	    <= 1'b0;
        ieu_addr_dst  	    <= 5'b0;
        ieu_mem_ren  	    <= 1'b0;
        ieu_mem_wen 	    <= 1'b0;
        ieu_memtoreg	    <= 1'b0;
        ieu_alu_result_dealy<= 32'd0;
        ieu_mem_addr	    <= 32'd0;
        ieu_store_data      <= 32'd0;
        ieu_func3              <= 3'd0;
        check_stall_Out     <= 2'b0;
        ldst_resume         <= 1'b0;
    end
    else begin
        ieu_regfile_en              <= idu_regfile_en;
        ieu_addr_dst 	    <= idu_addr_dst;
        ieu_mem_ren    	    <= idu_mem_ren;
        ieu_mem_wen  	    <= idu_mem_wen;
        ieu_memtoreg 	    <= idu_memtoreg;
        ieu_alu_result_dealy<= ieu_alu_result;
        ieu_mem_addr	    <= ieu_alu_result;
        ieu_store_data	    <= idu_store_data;
        ieu_func3              <= idu_func3;
        ldst_resume         <= mem_busy;
        check_stall_Out     <= check_stall_In;
    end
end

endmodule:IEU