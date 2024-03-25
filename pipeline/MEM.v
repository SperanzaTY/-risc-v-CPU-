
module MEM(
input clk_cpu,
input [31:0]addr_mem,
input [31:0]rD2_mem,
input [31:0]imm_mem,
input dram_we_mem,
input [1:0]wd_sel_mem,
output [31:0]wd_data_mem,
output [31:0]hazard_mem_data
);

assign hazard_mem_data = (wd_sel_mem == `alu ? addr_mem : (wd_sel_mem == `dram ? wd_data_mem : imm_mem));
data_mem dram_u(
  .a(addr_mem[15:2]),      // input wire [13 : 0] a
  .d(rD2_mem),      // input wire [31 : 0] d
  .clk(clk_cpu),  // input wire clk
  .we(dram_we_mem),    // input wire we
  .spo(wd_data_mem)  // output wire [31 : 0] qspo
);
endmodule
