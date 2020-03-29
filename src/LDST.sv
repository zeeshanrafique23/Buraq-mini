`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2020 06:05:18 PM
// Design Name: 
// Module Name: MEM_WB
// Project Name: 
// Target Devices: 
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

module LDST#(
parameter DataWidth = 32,
parameter RegAddrWidth = 5,
parameter AddrWidth = 15
)
(
    input brq_clk,
    input brq_rst,
    input stall,
    input ieu_regfile_en,
    input [2:0]ieu_func3,
    input [1:0]ldst_check_stall,
    input [DataWidth-1:0]ieu_alu_result,
    input [DataWidth-1:0]ldst_load_data_in,
    input [DataWidth-1:0]ieu_mem_addr,
    input [DataWidth-1:0]ieu_store_data,
    input [RegAddrWidth-1:0]ieu_addr_dst,
    input ieu_memtoreg,
    
    output logic ldst_regfile_en,
    output logic ldst_resume,wb_resume,
    output logic [2:0]ldst_byte_en,
    output logic [AddrWidth-1:0]ldst_mem_addr,
    output logic [DataWidth-1:0]ldst_alu_result,
    output logic [DataWidth-1:0]ldst_store_data,
    output logic [DataWidth-1:0]ldst_load_data,
    output logic [RegAddrWidth-1:0]ldst_addr_dst,
    output logic ldst_memtoreg
 );
logic mem_busy;
logic [1:0]wb_check_stall;
logic [1:0]byte_sel;
logic [AddrWidth-1:0]address;
logic [DataWidth-1:0]load_data;

assign ldst_store_data = ieu_store_data;
assign byte_sel = ieu_mem_addr[1:0];
assign address = ieu_mem_addr>>2;
assign ldst_mem_addr = address[AddrWidth-1:0];

always_comb begin
   if (ieu_func3 == 3'b000)begin
          if (byte_sel == 2'b00)
               ldst_byte_en = 3'b000;
     else if (byte_sel == 2'b01)
               ldst_byte_en = 3'b001; 
     else if (byte_sel == 2'b10)
               ldst_byte_en = 3'b010; 
     else if (byte_sel == 2'b11)
               ldst_byte_en = 3'b011;
   end 

   else if (ieu_func3 == 3'b001)begin
          if (byte_sel == 2'b0)
               ldst_byte_en = 3'b100; 
     else if (byte_sel == 2'b01)
               ldst_byte_en = 3'b101;    
   end

   else if (ieu_func3 == 3'b010)begin
          ldst_byte_en = 3'b110;
   end
end

always_comb begin
	if (ldst_byte_en ==3'b000)
		load_data = {24'b0,ldst_load_data_in[7:0]};   //lb//
   else if (ldst_byte_en ==3'b001)
                load_data = {24'b0,ldst_load_data_in[15:8]};
   else if (ldst_byte_en ==3'b010)
                load_data = {24'b0,ldst_load_data_in[23:16]};
   else if (ldst_byte_en ==3'b011)
                load_data = {24'b0,ldst_load_data_in[31:24]};
   else if (ldst_byte_en ==3'b100)
                load_data = {16'b0,ldst_load_data_in[15:0]};  //lh//
   else if (ldst_byte_en ==3'b101)
                load_data = {16'b0,ldst_load_data_in[31:16]};
   else if (ldst_byte_en ==3'b110)
                load_data = ldst_load_data_in;                //lw//
end

assign wb_resume   = (wb_check_stall[1])   ? 1'b1 : 1'b0;
assign ldst_resume = (ldst_check_stall[0]) ? 1'b1 : 1'b0;

always @ (posedge brq_clk)begin
    if (brq_rst)begin
        ldst_alu_result <= 32'd0;
        ldst_addr_dst   <= 5'd0;
        ldst_memtoreg   <= 1'b0;
        ldst_regfile_en <= 1'b0; 
        ldst_load_data  <= 32'd0; 
        wb_check_stall  <= 2'b0;   
    end
    else begin
        wb_check_stall  <= ldst_check_stall;
        ldst_load_data  <= load_data;
        ldst_alu_result <= ieu_alu_result;
        ldst_addr_dst   <= ieu_addr_dst;
        ldst_memtoreg   <= ieu_memtoreg;
        ldst_regfile_en <= ieu_regfile_en;
    end
end
endmodule: LDST
