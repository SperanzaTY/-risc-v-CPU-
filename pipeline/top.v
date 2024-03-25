module top(
    input clk,
    input rst_n,
    output        debug_wb_have_inst,   // WB阶段是否有指令 (对单周期CPU，此flag恒为1)
    output [31:0] debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意值)
    output        debug_wb_ena,         // WB阶段的寄存器写使能 (若wb_have_inst=0，此项可为任意值)
    output [4:0]  debug_wb_reg,         // WB阶段写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output [31:0] debug_wb_value        // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
);
wire [31:0]inst;
wire [31:0]res;
wire [31:0]wdata;
wire dram_we;
wire [31:0]rdata;
wire [31:0]pc;

//top输出
assign debug_wb_pc = pc_wb;
assign debug_wb_ena =rd_we_wb ;
assign debug_wb_value =data_wb ;
assign debug_wb_reg = rd_wb;
assign debug_wb_have_inst = have_inst;

wire [31:0] pc_if;
wire [31:0] addr_mem;
wire [31:0] rD2_mem;
wire dram_we_mem;

wire [31:0] pc_wb;
wire rd_we_wb ;
wire [4:0]  rd_wb;
wire [31:0] data_wb ;
wire have_inst;

assign pc = pc_if;
assign res = addr_mem;
assign wdata = rD2_mem;
assign dram_we = dram_we_mem;


wire rst_cpu;
assign rst_cpu = ~rst_n;

wire [31:0]inst_if;
wire [31:0]pc_id;
wire [31:0]inst_id;

wire rs2_sel_id;
wire rd_we_id;
wire dram_we_id;
wire [2:0] alu_sel_id;
wire [1:0] wd_sel_id;
wire [31:0] rD1_id;
wire [31:0] rD2_id;
wire [4:0] rs1_id;
wire [4:0] rs2_id;
wire [4:0] rd_id;
wire [31:0] imm_id;

wire rs2_sel_ex;
wire rd_we_ex;
wire dram_we_ex;
wire[1:0] wd_sel_ex;
wire[2:0] alu_sel_ex;
wire[31:0] rD1_ex;
wire[31:0] rD2_ex;
wire[4:0] rs1_ex;
wire[4:0] rs2_ex;
wire[4:0] rd_ex;
wire[31:0] pc_ex;
wire[31:0] imm_ex;
wire [31:0] pc_imm_ex;
wire[31:0] res_ex;
wire npc_sel_ex;
wire pc_sel_ex;

wire rd_we_mem;
wire[1:0] wd_sel_mem;
wire[4:0] rd_mem;
wire [31:0] wd_data_mem;
wire [31:0] imm_mem;
wire [31:0] pc_mem;
wire [4:0] rs1_mem;
wire [4:0] rs2_mem;

wire flush;
wire [2:0] branch_id;
wire [2:0] branch_ex;

wire [31:0] res_ex_risk;
wire [31:0] imm_ex_risk;
wire [31:0] mem_data_risk;
wire [31:0] wb_data_risk;
wire [2:0] rD1_sel;
wire [2:0] rD2_sel;
wire stop;
wire flag_ex;
wire flag_mem;

wire [6:0]funct7;
wire [2:0]funct3;
wire [6:0]opcode;
wire [2:0]imm_sel;
wire id_re;

assign res_ex_risk = res_ex;
assign imm_ex_risk = imm_ex;
assign wb_data_risk = data_wb;

inst_mem imem (
  .a(pc[15:2]),      // input wire [13 : 0] a
  .spo(inst[31:0])  // output wire [31 : 0] spo
);

data_mem dmem(
  .a(res[13:0]),      // input wire [13 : 0] a
  .d(wdata),      // input wire [31 : 0] d
  .clk(~clk),  // input wire clk
  .we(dram_we),    // input wire we
  .spo(rdata)  // output wire [31 : 0] spo
);

IF u_IF(.clk_cpu(clk),
              .rst_cpu(rst_cpu),
              .stop(stop),
              .pc_sel(pc_sel_ex),
              .npc_sel(npc_sel_ex),
              .pc_imm(pc_imm_ex),
              .res_alu(res_ex),
              .pc(pc_if),
              .inst(inst_if) );
              
IF_ID u_IF_ID(.clk_cpu(clk),
              .rst_cpu(rst_cpu),
              .pc_if(pc_if),
              .inst_if(inst_if),
              .flush(flush),
              .stop(stop),
              .pc_id(pc_id),
              .inst_id(inst_id) );
              
ID u_ID(.clk_cpu(clk),
                .rst_cpu(rst_cpu),
                .inst(inst_id),
                .imm_sel(imm_sel),
                .rd_we_wb(rd_we_wb),
                .data_wb(data_wb),
                .rD1_id(rD1_id),
                .rD2_id(rD2_id),
                .imm_id(imm_id),
                .funct3(funct3),
                .funct7(funct7),
                .opcode(opcode),
                .rd_wb(rd_wb),
                .rd_id(rd_id),
                .rs1_id(rs1_id),
                .rs2_id(rs2_id) );
                
ID_EX u_ID_EX(.clk_cpu(clk),
              .rst_cpu(rst_cpu),
              .rs2_sel_id(rs2_sel_id),
              .rd_we_id(rd_we_id),
              .dram_we_id(dram_we_id),
              .rD1_sel(rD1_sel),
              .rD2_sel(rD2_sel),
              .hazard_ex_res(res_ex_risk),
              .hazard_ex_imm(imm_ex_risk),
              .hazard_mem_data(mem_data_risk),
              .hazard_wb_wdata(wb_data_risk),
              .alu_sel_id(alu_sel_id),
              .wd_sel_id(wd_sel_id),
              .pc_id(pc_id),
              .rD1_id(rD1_id),
              .rD2_id(rD2_id),
              .rd_id(rd_id),
              .imm_id(imm_id),
              .branch_id(branch_id),
              .flush(flush),
              .stop(stop),
              .rs2_sel_ex(rs2_sel_ex),
              .rd_we_ex(rd_we_ex),
              .dram_we_ex(dram_we_ex),
              .wd_sel_ex(wd_sel_ex),
              .alu_sel_ex(alu_sel_ex),
              .rD1_ex(rD1_ex),
              .rD2_ex(rD2_ex),
              .rd_ex(rd_ex),
              .pc_ex(pc_ex),
              .imm_ex(imm_ex),
              .branch_ex(branch_ex),
              .flag_ex(flag_ex) );
              
EX u_EX(.rst_cpu(rst_cpu),
                  .pc_ex(pc_ex),
                  .rD1_ex(rD1_ex),
                  .rD2_ex(rD2_ex),
                  .imm_ex(imm_ex),
                  .alu_sel_ex(alu_sel_ex),
                  .branch_ex(branch_ex),
                  .rs2_sel_ex(rs2_sel_ex),
                  .res_ex(res_ex),
                  .pc_imm_ex(pc_imm_ex),
                  .flush(flush),
                  .pc_sel(pc_sel_ex),
                  .npc_sel(npc_sel_ex) );
                  
EX_MEM u_EX_MEM(.clk_cpu(clk),
                .rst_cpu(rst_cpu),
                .dram_we_ex(dram_we_ex),
                .rd_we_ex(rd_we_ex),
                .wd_sel_ex(wd_sel_ex),
                .rd_ex(rd_ex),
                .res_ex(res_ex),
                .rD2_ex(rD2_ex),
                .imm_ex(imm_ex),
                .pc_ex(pc_ex),
                .flag_ex(flag_ex),
                .addr_mem(addr_mem),
                .rd_we_mem(rd_we_mem),
                .dram_we_mem(dram_we_mem),
                .wd_sel_mem(wd_sel_mem),
                .rd_mem(rd_mem),
                .rD2_mem(rD2_mem),
                .imm_mem(imm_mem),
                .pc_mem(pc_mem),
                .flag_mem(flag_mem) );
                
MEM u_MEM(.clk_cpu(clk),
                .addr_mem(addr_mem),
                .rD2_mem(rD2_mem),
                .imm_mem(imm_mem),
                .dram_we_mem(dram_we_mem),
                .wd_sel_mem(wd_sel_mem),
                .wd_data_mem(wd_data_mem),
                .hazard_mem_data(mem_data_risk) );
                
MEM_WB u_MEM_WB(.clk_cpu(clk),
                .rst_cpu(rst_cpu),
                .rd_we_mem(rd_we_mem),
                .wd_sel_mem(wd_sel_mem),
                .wd_data_mem(wd_data_mem),
                .addr_mem(addr_mem),
                .imm_mem(imm_mem),
                .pc_mem(pc_mem),
                .rd_mem(rd_mem),
                .flag_mem(flag_mem),
                .rd_we_wb(rd_we_wb),
                .data_wb(data_wb),
                .rd_wb(rd_wb),
                .pc_wb(pc_wb),
                .have_inst(have_inst) );
                
hazard u_hazard(.clk_cpu(clk),
            .rst_cpu(rst_cpu),
            .rs1_id(rs1_id),
            .rs2_id(rs2_id),
            .wd_sel_ex(wd_sel_ex),
            .rd_ex(rd_ex),
            .rd_mem(rd_mem),
            .rd_we_ex(rd_we_ex),
            .id_re(id_re),
            .rd_we_mem(rd_we_mem),
            .rd_wb(rd_wb),
            .rd_we_wb(rd_we_wb),
            .rD1_sel(rD1_sel),
            .rD2_sel(rD2_sel),
            .stop(stop) );
            
control u_control(.rst_cpu(rst_cpu),
                  .funct3(funct3),
                  .funct7(funct7),
                  .opcode(opcode),
                  .branch(branch_id),
                  .imm_sel(imm_sel),
                  .wd_sel(wd_sel_id),
                  .rd_we(rd_we_id),
                  .alu_sel(alu_sel_id),
                  .rs2_sel(rs2_sel_id),
                  .dram_we(dram_we_id),
                  .id_re(id_re) );


endmodule

