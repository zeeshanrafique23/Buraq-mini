`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MERL-UIT
// Engineer: 
// 
// Create Date: 12/21/2019 06:26:51 PM
// Design Name: Buraq-mini-RV32IM
// Module Name: Buraq-RV32IM
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

module Buraq_RV32IM #(
parameter DataWidth=32,
parameter AddrWidth=15,
parameter RegAddrWidth=5
)
(
    input  brq_clk,
    input  brq_rst,
    input  [DataWidth-1:0]inst_mem_data,Data_mem_dataOut,
    output logic [DataWidth-1:0]Data_mem_dataIn,
    output logic [AddrWidth-1:0]inst_mem_address,Data_mem_address,
    output logic Data_mem_read_en,Data_mem_write_en,
    output logic [2:0]ldst_byte_en,
    output logic [DataWidth-1:0]reg_out
);
logic [DataWidth-1:0]idu_store_data;
logic [1:0]idu_next_pc_sel;
logic idu_branch;
logic wb_resume;
logic stall;
logic ieu_stall;
logic [1:0]idu_check_stall;
logic [1:0]check_stall;
logic [RegAddrWidth-1:0]idu_src1_reg;
logic [RegAddrWidth-1:0]idu_src2_reg;
logic [DataWidth-1:0]ldst_alu_result;
logic [DataWidth-1:0]ifu_fetch_inst;
logic [DataWidth-1:0]ifu_pc;
logic [DataWidth-1:0]idu_branch_addr;
logic [DataWidth-1:0]idu_jal_addr;
logic [DataWidth-1:0]idu_jalr_addr;
logic [DataWidth-1:0]Wbu_result;
logic [DataWidth-1:0]ieu_mem_addr;
logic [1:0]idu_op_a_sel;
logic idu_op_b_sel;
logic [RegAddrWidth-1:0]wbu_addr_dst;
logic [RegAddrWidth-1:0]idu_addr_dst;
logic [RegAddrWidth-1:0]ieu_addr_dst;
logic [DataWidth-1:0]idu_immediate;
logic [DataWidth-1:0]idu_pc;
logic [DataWidth-1:0]ieu_store_data;
logic [DataWidth-1:0]idu_data_1;
logic [DataWidth-1:0]idu_data_2;
logic idu_memtoreg;
logic idu_mem_ren;
logic idu_mem_wen;
logic [DataWidth-1:0]ieu_alu_result;
logic [2:0]idu_aluop;
logic [2:0]ieu_func3;
logic [2:0]idu_func3;
logic [6:0]idu_func7;
logic [1:0]ieu_check_Stall;
logic idu_regfile_en;          //register file enable from decode to execute
logic ieu_regfile_en;           //register file enable from execute to writeBack
logic idu_flush;
logic ldst_resume;
logic ieu_memtoreg;
logic [DataWidth-1:0]ldst_load_data;
logic [DataWidth-1:0]ALU_RESULT;
logic [RegAddrWidth-1:0]ldst_addr_dst;
logic ldst_regfile_en;
logic ldst_memtoreg,idu_stall;
                                     ///********INSTANTIATING MODULES********///

IFU#(DataWidth,AddrWidth) Fetch_unit
(
     .brq_clk(brq_clk),
     .brq_rst(brq_rst),
     .ifu_next_pc_sel(idu_next_pc_sel),
     .idu_branch(idu_branch),
     .idu_flush(idu_flush),
     .idu_stall(check_stall),
     .ieu_stall(ieu_stall),
     .idu_branch_addr(idu_branch_addr),
     .idu_jal_addr(idu_jal_addr),
     .idu_jalr_addr(idu_jalr_addr),
     .inst_mem_data(inst_mem_data),
     //OUTPUT//
     .ifu_stall(stall),
     .inst_mem_address(inst_mem_address),
     .ifu_pc(ifu_pc),
     .ifu_fetch_inst(ifu_fetch_inst)
);

IDU #(DataWidth,RegAddrWidth) Decode_unit
(
     .brq_clk(brq_clk),
     .brq_rst(brq_rst),
     .ifu_stall(stall),
     .regEN_EX(idu_regfile_en),
     .regEN_MEM(ieu_regfile_en),
     .regEN_WB(ldst_regfile_en),
     .wb_resume(wb_resume),
     .ldst_resume(ldst_resume),
     .ifu_fetch_inst(ifu_fetch_inst),
     .ifu_pc(ifu_pc),
     .ldst_mem_read_en(Data_mem_read_en),
     .ieu_addr_dst(ieu_addr_dst),
     .wbu_addr_dst(wbu_addr_dst),
     .Forwarded_Data_EX(ALU_RESULT),
     .Forwarded_Data_MEM1(ieu_alu_result),    
     .Forwarded_Data_MEM2(Data_mem_dataOut),
     .Forwarded_Data_WB(Wbu_result),
     .Wbu_result(Wbu_result),     // comes from WB-stage                        
     //OUTPUTS//
     .idu_pc(idu_pc),
     .idu_immediate(idu_immediate),
     .idu_addr_dst(idu_addr_dst),     // goes to EX-stage then go to MEM,WB
     .idu_data_1(idu_data_1),
     .idu_data_2(idu_data_2),
     .idu_branch_addr(idu_branch_addr),
     .idu_jal_addr(idu_jal_addr),
     .idu_jalr_addr(idu_jalr_addr),
     .idu_op_a_sel(idu_op_a_sel),
     .idu_op_b_sel(idu_op_b_sel),
     .idu_src1_reg(idu_src1_reg),
     .idu_src2_reg(idu_src2_reg),
     .idu_check_stall(idu_check_stall),
     .check_stall(check_stall),
     .idu_store_data(idu_store_data),
     .idu_mem_ren(idu_mem_ren),
     .idu_memtoreg(idu_memtoreg),
     .idu_mem_wen(idu_mem_wen),
     .idu_flush(idu_flush),
     .idu_branch(idu_branch),
     .idu_next_pc_sel(idu_next_pc_sel),
     .idu_aluop(idu_aluop),
     .idu_func3(idu_func3),
     .idu_func7(idu_func7),
     .idu_regfile_en(idu_regfile_en),
     .RegOut(reg_out)
);

IEU #(DataWidth,AddrWidth,RegAddrWidth) Execute_unit
(
     .brq_clk(brq_clk),
     .brq_rst(brq_rst),
     .stall(stall),
     .ieu_immediate(idu_immediate),
     .ieu_pc(idu_pc),
     .ieu_op_a_sel(idu_op_a_sel),
     .ieu_op_b_sel(idu_op_b_sel),
     .check_stall_In(idu_check_stall),
     .idu_store_data(idu_store_data),
     .ldst_regfile_en(ldst_regfile_en),
     .wbu_addr_dst(wbu_addr_dst),
     .wbu_result(Wbu_result),
     .idu_data_1(idu_data_1),
     .idu_data_2(idu_data_2),
     .idu_addr_dst(idu_addr_dst), 
     .ieu_src1_reg(idu_src1_reg),
     .ieu_src2_reg(idu_src2_reg),
     .ldst_mem_result(Data_mem_dataOut),
     .idu_func3(idu_func3),
     .idu_func7(idu_func7),
     .idu_aluop(idu_aluop),
     .idu_memtoreg(idu_memtoreg),
     .idu_mem_wen(idu_mem_wen),
     .idu_mem_ren(idu_mem_ren),
     .idu_regfile_en(idu_regfile_en),
     //OUTPUTS//
     .check_stall_Out(ieu_check_Stall),
     .ieu_func3(ieu_func3),
     .ieu_stall(ieu_stall),
     .ieu_memtoreg(ieu_memtoreg),
     .ieu_mem_wen(Data_mem_write_en),
     .ieu_mem_ren(Data_mem_read_en),
     .ieu_regfile_en(ieu_regfile_en),
     .ieu_mem_addr(ieu_mem_addr),      //It will give address to the memory
     .ieu_alu_result(ALU_RESULT),
     .ieu_alu_result_dealy(ieu_alu_result),
     .ieu_addr_dst(ieu_addr_dst),
     .ieu_store_data(ieu_store_data)
);

LDST #(DataWidth,RegAddrWidth)MEM_WB_REG      // *MEM_WB_REG*
(
     .brq_clk(brq_clk),
     .brq_rst(brq_rst),
     .stall(stall),
     .ieu_func3(ieu_func3),
     .ldst_check_stall(ieu_check_Stall),
     .ieu_store_data(ieu_store_data),
     .ieu_mem_addr(ieu_mem_addr),
     .ieu_alu_result(ieu_alu_result),
     .ieu_addr_dst(ieu_addr_dst),
     .ldst_load_data_in(Data_mem_dataOut),
     .ieu_memtoreg(ieu_memtoreg),
     .ieu_regfile_en(ieu_regfile_en),
     //OUTPUTS//
     .wb_resume(wb_resume),
     .ldst_resume(ldst_resume),
     .ldst_byte_en(ldst_byte_en),
     .ldst_mem_addr(Data_mem_address),
     .ldst_store_data(Data_mem_dataIn),
     .ldst_alu_result(ldst_alu_result),
     .ldst_load_data(ldst_load_data),
     .ldst_addr_dst(ldst_addr_dst),
     .ldst_memtoreg(ldst_memtoreg),
     .ldst_regfile_en(ldst_regfile_en)
);

WBU #(DataWidth,RegAddrWidth) WriteBack_unit
( 
     .ldst_addr_dst(ldst_addr_dst),
     .ldst_memtoreg(ldst_memtoreg),
     .ldst_alu_result(ldst_alu_result),
     .ldst_load_data(ldst_load_data),// Mem_Data_WB
     //OUTPUTS//
     .wbu_result(Wbu_result),
     .wbu_addr_dst(wbu_addr_dst)
);

endmodule:Buraq_RV32IM