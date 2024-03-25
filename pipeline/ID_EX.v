
module ID_EX(
input clk_cpu,
input rst_cpu,
input rs2_sel_id,
input rd_we_id,
input dram_we_id,
input [2:0] rD1_sel,
input [2:0] rD2_sel,
input [31:0] hazard_ex_res,
input [31:0] hazard_ex_imm,
input [31:0] hazard_mem_data,
input [31:0] hazard_wb_wdata,
input [2:0] alu_sel_id,
input [1:0] wd_sel_id,
input [31:0] pc_id,
input [31:0]rD1_id,
input [31:0]rD2_id,
input [4:0]rd_id,
input [31:0]imm_id,
input [2:0] branch_id,
input flush,
input stop,
output reg rs2_sel_ex,
output reg rd_we_ex,
output reg dram_we_ex,
output reg [1:0] wd_sel_ex,
output reg [2:0] alu_sel_ex,
output reg[31:0] rD1_ex,
output reg[31:0] rD2_ex,
output reg [4:0] rd_ex,
output reg [31:0] pc_ex,
output reg [31:0] imm_ex,
output reg [2:0] branch_ex,
output reg flag_ex
);
always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu)
        flag_ex <= 0;
    else if(flush) 
        flag_ex <= 1;
    else 
        flag_ex <= 0;
end

always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu) 
        branch_ex <= 0;
    else if(stop)
        branch_ex <= branch_ex;
    else if(flush) 
        branch_ex <= 0;
    else 
        branch_ex <= branch_id;
end

always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu) 
        rs2_sel_ex <= 0;
    else if(stop) 
        rs2_sel_ex <= rs2_sel_ex;
    else if(flush) 
        rs2_sel_ex <= 0;
    else 
        rs2_sel_ex <= rs2_sel_id;
end

always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu) 
        alu_sel_ex <= 0;
    else if(stop) 
        alu_sel_ex <= alu_sel_ex;
    else if(flush) 
        alu_sel_ex <= 0;
    else 
        alu_sel_ex <= alu_sel_id;
end

always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu) 
        rd_we_ex <= 0;
    else if(stop)
        rd_we_ex <= rd_we_ex;
    else if(flush) 
        rd_we_ex <= 0;
    else 
        rd_we_ex <= rd_we_id;
end

always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu) 
        dram_we_ex <= 0;
    else if(stop)
        dram_we_ex <= dram_we_ex;
    else if(flush) 
        dram_we_ex <= 0;
    else 
        dram_we_ex <= dram_we_id;
end

always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu) 
        wd_sel_ex <= 0;
    else if(stop) 
        wd_sel_ex <= wd_sel_ex;
    else if(flush) 
        wd_sel_ex <= 0;
    else 
        wd_sel_ex <= wd_sel_id;
end

always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu) 
        rd_ex <= 0;
    else if(stop)
        rd_ex <= rd_ex;
    else if(flush) 
        rd_ex <= 0;
    else 
        rd_ex <= rd_id;
end

always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu)
        pc_ex <= 32'hffff_fffc;
    else if(stop)
        pc_ex <= pc_ex;
    else if(flush) 
        pc_ex <= 32'hffff_fffc;
    else 
        pc_ex <= pc_id;
end

always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu)
        imm_ex <= 0;
    else if(stop)
        imm_ex <= imm_ex;
    else if(flush) 
        imm_ex <= 0;
    else 
        imm_ex <= imm_id;
end

always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu) rD1_ex <= 0;
    else if(stop) rD1_ex <= rD1_ex;
    else if(flush) rD1_ex <= 0;
    else if(rD1_sel == 'b000) rD1_ex <= rD1_id;             //无冒险
    else if(rD1_sel == 'b001) rD1_ex <= hazard_ex_res;      //前递alu结果
    else if(rD1_sel == 'b010) rD1_ex <= hazard_ex_imm;      //前递imm立即数
    else if(rD1_sel == 'b011) rD1_ex <= hazard_mem_data;    //前递写回rd的数据
    else if(rD1_sel == 'b100) rD1_ex <= hazard_wb_wdata;    //前递写回rd的数据
end

always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu)rD2_ex <= 0;
    else if(stop) rD2_ex <= rD2_ex;
    else if(flush) rD2_ex <= 0;
    else if(rD2_sel == 'b000) rD2_ex <= rD2_id;
    else if(rD2_sel == 'b001) rD2_ex <= hazard_ex_res;
    else if(rD2_sel == 'b010) rD2_ex <= hazard_ex_imm;
    else if(rD2_sel == 'b011) rD2_ex <= hazard_mem_data;
    else if(rD2_sel == 'b100) rD2_ex <= hazard_wb_wdata;
end
endmodule

