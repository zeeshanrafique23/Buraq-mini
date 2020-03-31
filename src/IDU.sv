`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MERL
// Engineer: 
// 
// Create Date: 12/20/2019 07:26:31 PM
// Design Name: BSV32I_SSC
// Module Name: Decode
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


module IDU#(
parameter DataWidth=32,
parameter RegAddrWidth=5
)
(
    input brq_clk,
    input brq_rst,
    input ldst_resume,wb_resume,
    input regEN_EX,regEN_MEM,regEN_WB,ldst_mem_read_en,ifu_stall,
    input [RegAddrWidth-1:0]ieu_addr_dst,wbu_addr_dst,
    input [DataWidth-1:0]Forwarded_Data_EX,Forwarded_Data_MEM1,Forwarded_Data_MEM2,Forwarded_Data_WB,
    input [DataWidth-1:0]ifu_fetch_inst,
    input [DataWidth-1:0]ifu_pc,
    input [DataWidth-1:0]Wbu_result,                 // comes after WB-stage

    output logic [1:0]idu_check_stall,check_stall,
    output logic idu_branch,
    output logic idu_regfile_en,
    output logic [RegAddrWidth-1:0]idu_addr_dst,   // goes to EX-stage then go to MEM,WB
    output logic [RegAddrWidth-1:0]idu_src1_reg,
    output logic [RegAddrWidth-1:0]idu_src2_reg,
    output logic idu_mem_ren,idu_memtoreg,idu_mem_wen,idu_flush,
    output logic [2:0] idu_aluop,
    output logic [1:0] idu_op_a_sel,
    output logic idu_op_b_sel,
    output logic [1:0]idu_next_pc_sel,
    output logic [2:0]idu_func3,
    output logic [6:0]idu_func7,
    output logic [DataWidth-1:0]idu_pc,
    output logic [DataWidth-1:0]idu_immediate,
    output logic [DataWidth-1:0]idu_branch_addr,idu_jalr_addr,idu_jal_addr,
    output logic [DataWidth-1:0]idu_data_1,
    output logic [DataWidth-1:0]idu_data_2,
    output logic [DataWidth-1:0]idu_store_data,
    output logic [DataWidth-1:0]RegOut
	
);

logic [DataWidth-1:0]Instruction;
logic [DataWidth-1:0]ImmOUT;
logic Branch_controller;
logic Branch_control_unit;
logic [DataWidth-1:0]readData1;
logic [DataWidth-1:0]readData2;
logic [RegAddrWidth-1:0]SRC_Reg_1;
logic [RegAddrWidth-1:0]SRC_Reg_2;
logic [1:0]ImmSel;
logic [DataWidth-1:0]SOURCE_A;
logic [DataWidth-1:0]SOURCE_B;
logic [DataWidth-1:0]source_1;
logic [DataWidth-1:0]source_2;
logic [1:0]OPERAND_A_SEL;
logic OPERAND_B_SEL;
logic [2:0]func3;
logic [6:0]func7;
logic mem_Read,mem_write;
logic regFileWriteEn,memtoRegister;
logic [2:0]ALU_Op;
logic [RegAddrWidth-1:0]destReg;
logic [6:0]opcode;
logic [DataWidth-1:0]I_imm;
logic [DataWidth-1:0]S_imm;
logic [DataWidth-1:0]U_imm;
logic [(DataWidth-1)-7:0]instruction_imm; // instruction without opcode
logic [3:0]op_A_sel;
logic [3:0]op_B_sel;

assign Instruction = ifu_fetch_inst;

assign opcode    = Instruction[6:0];
assign destReg   = Instruction[11:7];
assign SRC_Reg_1 = Instruction[19:15];
assign SRC_Reg_2 = Instruction[24:20];
assign func3     = Instruction[14:12];
assign func7     = Instruction[31:25];

localparam No_of_registers = 32;

/////////////////////////////////////////////////////////////////////////
 always_comb begin
    if (idu_next_pc_sel == 2'b10 || idu_next_pc_sel == 2'b11)
        idu_flush = 1'b1;
    else if (idu_next_pc_sel == 2'b01 && idu_branch == 1'b1)
	idu_flush = 1'b1;
    else 
	idu_flush = 1'b0;
 end

always @(posedge brq_clk)begin
    if (brq_rst)begin 
        {idu_func3,idu_func7,idu_check_stall,idu_mem_ren,idu_mem_wen,idu_memtoreg,idu_aluop,idu_regfile_en,idu_pc,idu_op_a_sel}<= 0;
        {idu_store_data,idu_src1_reg,idu_src2_reg,idu_immediate,idu_data_1,idu_data_2,idu_addr_dst,idu_op_b_sel}<=0;  
    end
    else if(idu_flush)begin
        {idu_func3,idu_func7,idu_check_stall,idu_mem_ren,idu_mem_wen,idu_memtoreg,idu_aluop}<= 0;
        {idu_store_data,idu_src1_reg,idu_src2_reg,idu_immediate,idu_data_1,idu_data_2}<=0;
        {idu_regfile_en,idu_addr_dst,idu_pc,idu_op_a_sel,idu_op_b_sel}<={regFileWriteEn,destReg,ifu_pc,OPERAND_A_SEL,OPERAND_B_SEL};
    end
    else if (ifu_stall)begin
        idu_src1_reg      <= 5'b0;
        idu_src2_reg      <= 5'b0;
        idu_regfile_en        <= 1'b0;
        idu_mem_ren           <= 1'b0;
        idu_mem_wen          <= 1'b0;
        idu_immediate     <= 32'b0;
    end
    else begin
        idu_pc            <= ifu_pc;
        idu_immediate     <= ImmOUT;
        idu_src1_reg      <= SRC_Reg_1;
        idu_src2_reg      <= SRC_Reg_2;          
        idu_addr_dst      <= destReg;
        idu_func3         <= func3;
        idu_func7         <= func7;
        idu_regfile_en        <= regFileWriteEn;
        idu_mem_ren           <= mem_Read;
        idu_mem_wen          <= mem_write;
        idu_memtoreg          <= memtoRegister;
        idu_aluop		  <= ALU_Op;
        idu_data_1        <= source_1;
        idu_data_2        <= source_2;
        idu_store_data    <= SOURCE_B;
        idu_check_stall   <= check_stall;
        idu_op_a_sel      <= OPERAND_A_SEL;
        idu_op_b_sel      <= OPERAND_B_SEL; 
    end
end
////////////////////////////////////////////////////////////////////
RegFile #(DataWidth,No_of_registers,RegAddrWidth) RegisterFile
     (
        .brq_clk(brq_clk),
        .brq_rst(brq_rst),
        .writeEn(regEN_WB),
        .source1(SRC_Reg_1),
        .source2(SRC_Reg_2),
        .writeDataSel(wbu_addr_dst),
        .writeData(Wbu_result),
         //OUTPUTS//
        .readData1(readData1),
        .readData2(readData2),
        .Reg_Out(RegOut)
     );

Control_Unit Control (
        .opcode(opcode),
         //OUTPUTS//
        .branch_op(Branch_control_unit),
        .memRead(mem_Read),
        .memtoReg(memtoRegister),
        .memWrite(mem_write),
        .regWriteEn(regFileWriteEn),
        .next_PC_sel(idu_next_pc_sel),
        .operand_A_sel(OPERAND_A_SEL),
        .operand_B_sel(OPERAND_B_SEL),
        .ALUOp(ALU_Op),
        .extend_sel(ImmSel)
    );

Imm_Gen #(DataWidth) ImmediateGeneration
    (
        .pc(ifu_pc),
        .instruction(instruction_imm),
	 //OUTPUTS//
        .i_type(I_imm),
        .u_type(U_imm),
        .s_type(S_imm),
        .sb_type(idu_branch_addr),
        .uj_type(idu_jal_addr)        
    );
    
assign ImmOUT = (ImmSel==2'b00) ? I_imm:
                (ImmSel==2'b01) ? S_imm:
                (ImmSel==2'b10) ? U_imm: 32'd0 ;


assign instruction_imm = Instruction[31:7];
assign idu_jalr_addr = (ImmOUT + SOURCE_A) & 32'hfffffffe;

/////////////////////////////////////////////////////////
UnConditional_Forwarding#(DataWidth,RegAddrWidth) Forwarding_4_Control_Hazard
(   
     .Reg_File_EN_Memory_stage(regEN_MEM),
     .Reg_File_EN_WrBk_stage(regEN_WB),
     .Reg_File_EN_Execute_stage(regEN_EX),
     .Mem_Read_EN_Execute_stage(idu_mem_ren),
     .Mem_Read_EN_Memory_stage(ldst_mem_read_en),
     .WriteBack_reg_Execute_stage(idu_addr_dst),
     .WriteBack_reg_Memory_stage(ieu_addr_dst),
     .WriteBack_reg_WrBk_stage(wbu_addr_dst),
     .IF_ID_RS1(SRC_Reg_1),
     .IF_ID_RS2(SRC_Reg_2),
     //OUTPUT//
     .Operand_A_control(op_A_sel),
     .Operand_B_control(op_B_sel)  
);

always_comb begin

   SOURCE_A = op_A_sel == 4'b1000 ?  Forwarded_Data_EX:
              op_A_sel == 4'b0010 ?  Forwarded_Data_MEM1:
              op_A_sel == 4'b0001 ?  Forwarded_Data_WB: 
              readData1;

   SOURCE_B = op_B_sel == 4'b1000 ?  Forwarded_Data_EX:
              op_B_sel == 4'b0010 ?  Forwarded_Data_MEM1:
              op_B_sel == 4'b0001 ?  Forwarded_Data_WB: 
              readData2;
/////////////////////////////////////////////////////////////////////
   source_1 = op_A_sel == 4'b0001 ?  Forwarded_Data_WB : readData1;//        STRUCTURAL HAZARD
   source_2 = op_B_sel == 4'b0001 ?  Forwarded_Data_WB : readData2;//        `````````````````
/////////////////////////////////////////////////////////////////////  
check_stall = (op_A_sel==4'b0100 || op_B_sel==4'b0100) ? 2'b01:
              (op_A_sel==4'b0011 || op_B_sel==4'b0011) ? 2'b10: 
              (ldst_resume | wb_resume) ? 2'b00 : 2'b00;
end

Branch_Controller_Unit#(DataWidth) Branch_Controller_Unit
( 
    .func3(func3),
    .SRC_1(SOURCE_A),
    .SRC_2(SOURCE_B),
    //OUTPUT//
    .Branch(Branch_controller)
);

assign idu_branch = Branch_control_unit & Branch_controller;

endmodule:IDU