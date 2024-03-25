`include "param.v"
module MEM_WB(
input clk_cpu,
input rst_cpu,
input rd_we_mem,
input [1:0]wd_sel_mem,
input [31:0]wd_data_mem,
input [31:0]addr_mem,
input [31:0]imm_mem,
input [31:0]pc_mem,
input [4:0] rd_mem,
input flag_mem,
output reg rd_we_wb,
output reg[31:0]data_wb,
output reg[4:0]rd_wb,
output reg [31:0]pc_wb,
output reg have_inst
);
always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu)
        have_inst <= 0;
    else if(pc_wb != pc_mem && ~flag_mem)
        have_inst <= 1;
    else 
        have_inst <= 0;
end

always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu)
        rd_we_wb <= 0;
    else 
        rd_we_wb <= rd_we_mem;
end

always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu)
        rd_wb <= 0;
    else 
        rd_wb <= rd_mem;
end

always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu)
        pc_wb <= 32'hffff_fffc;
    else 
        pc_wb <= pc_mem;
end

always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu) 
        data_wb <= 0;
    else 
    case(wd_sel_mem)
    `alu:data_wb <= addr_mem;
    `imm:data_wb <= imm_mem;
    `pc4:data_wb <= pc_mem + 4;
    `dram:data_wb <= wd_data_mem;
    endcase
end



endmodule
