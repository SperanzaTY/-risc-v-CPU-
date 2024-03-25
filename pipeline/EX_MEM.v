
module EX_MEM(
input clk_cpu,
input rst_cpu,
input dram_we_ex,
input rd_we_ex,
input [1:0] wd_sel_ex,
input [4:0] rd_ex,
input [31:0]res_ex,
input [31:0]rD2_ex,
input [31:0]imm_ex,
input [31:0]pc_ex,
input flag_ex,
output reg[31:0]addr_mem,
output reg rd_we_mem,
output reg dram_we_mem,
output reg [1:0]wd_sel_mem,
output reg [4:0]rd_mem,
output reg [31:0]rD2_mem,
output reg [31:0]imm_mem,
output reg [31:0]pc_mem,
output reg flag_mem
);

always@(posedge clk_cpu or posedge rst_cpu) begin
    if(rst_cpu) begin
        addr_mem <= 0;
        rd_we_mem <= 0;
        dram_we_mem <= 0;
        wd_sel_mem <= 0;
        rd_mem <= 0;
        rD2_mem <= 0;
        imm_mem <= 0;
        flag_mem <= 0;
        pc_mem <= 32'hffff_fffc;
    end
    else begin
        addr_mem <= res_ex;
        rd_we_mem <= rd_we_ex;
        dram_we_mem <= dram_we_ex;
        wd_sel_mem <= wd_sel_ex;
        rd_mem <= rd_ex;
        rD2_mem <= rD2_ex;
        imm_mem <= imm_ex;
        flag_mem <= flag_ex;
        pc_mem <= pc_ex;
    end
end
endmodule
