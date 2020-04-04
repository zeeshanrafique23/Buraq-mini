`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MERL-UIT
// Engineer: 
// 
// Create Date: 12/21/2019 04:40:34 PM
// Design Name: Buraq-mini-RV32IM
// Module Name: IFU
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


module IFU #(
parameter HalfWord =16,
parameter DataWidth=32,
parameter AddrWidth=15
)
(
    input brq_clk,
    input brq_rst,
    input [1:0]ifu_next_pc_sel,
    input idu_branch,idu_flush,
    input [1:0]idu_stall,
    input ieu_stall,
    input [DataWidth-1:0]idu_branch_addr,
    input [DataWidth-1:0]idu_jalr_addr,
    input [DataWidth-1:0]idu_jal_addr,
    input [HalfWord-1:0]inst_mem_lsb,
    input [HalfWord-1:0]inst_mem_msb,
    output logic ifu_stall,
    output logic [AddrWidth-1:0]inst_mem_address,
    output logic [DataWidth-1:0]ifu_pc,
    output logic [DataWidth-1:0]ifu_fetch_inst

);
logic i_type;
logic [DataWidth-1:0]instruction;
logic [DataWidth-1:0]PC_reg;
logic [DataWidth-1:0]PC;
//////////////////////////////////////////////////////////////////////////////////////
Comp_Ins #(DataWidth) ins_compressed (inst_mem_lsb,inst_mem_msb,i_type,instruction);//	Module Instantiation for compressed instruction
//////////////////////////////////////////////////////////////////////////////////////

always @ (posedge brq_clk)begin
    if (brq_rst)
        PC_reg <= 32'b0;  
    else 
    if (ifu_stall)
        PC_reg <=  PC_reg;
    else
        begin
	if (!i_type)begin
	      PC_reg <= PC_reg + 32'd2;
	end
        else begin
        	if (ifu_next_pc_sel == 2'b10) begin               //JAL
        	    PC_reg <=  idu_jal_addr;
	 	end
                else if (ifu_next_pc_sel == 2'b11)begin           //JALR
                PC_reg <=  idu_jalr_addr;
		end
       		else if (ifu_next_pc_sel == 2'b01) begin          //Branch
       		           if (idu_branch == 1'b1) begin
       		               PC_reg <= idu_branch_addr;
		           end
       		           else begin
       		               PC_reg <= PC_reg + 32'd4;
		           end 
        	end
        	else if (ifu_next_pc_sel == 2'b00)begin      // PC + 4
   			   PC_reg <= PC_reg + 32'd4;
        	end
		else begin
			  PC_reg <= PC_reg + 32'd4;
		end
    	 end
     end
end

assign PC = PC_reg;
assign inst_mem_address  = PC[16:1];
//////////////////////////////////////////////////////////
Stall_Controller Staller(idu_stall,ieu_stall,ifu_stall);//    Stalling Module
//////////////////////////////////////////////////////////
    always@(posedge brq_clk)begin
        if(brq_rst)begin
	    ifu_fetch_inst<=32'd0;
            ifu_pc <= 32'd0;
	end
        else if(ifu_stall)begin
	    ifu_pc <= ifu_pc;
            ifu_fetch_inst<=ifu_fetch_inst;
	end
        else if(idu_flush)begin
	    ifu_fetch_inst<=32'd0;
            ifu_pc <= PC;
        end
        else begin
            ifu_pc <= PC;
            ifu_fetch_inst<=instruction;
        end    
    end  

endmodule:IFU
