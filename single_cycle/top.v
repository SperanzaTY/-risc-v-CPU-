
module top(
    input clk,
    input rst_n,
    output        debug_wb_have_inst,   // WB阶段是否有指令 (对单周期CPU，此flag恒为1)
    output [31:0] debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意值)
    output        debug_wb_ena,         // WB阶段的寄存器写使能 (若wb_have_inst=0，此项可为任意值)
    output [4:0]  debug_wb_reg,         // WB阶段写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output [31:0] debug_wb_value        // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
);
    
    wire [31:0]pc;
    wire [31:0]npc;
    wire [31:0]sext;
    wire branch;
    wire [31:0]alu_c;
    wire [31:0]pc4;
    wire [31:0]WD;
    wire [31:0]rs1;
    wire [31:0]rs2;
    wire [31:0]dram;
    
    wire [3:0]alu_op;
    wire [2:0]B_op;
    wire alub_sel;
    wire dram_we;
    wire [1:0]npc_op;
    wire [1:0]wd_sel;
    wire rf_we;
    wire [3:0]sext_op;
    

    wire [31:0] instruction;
    
    assign debug_wb_have_inst = 1;
    assign debug_wb_pc = pc;
    assign debug_wb_ena = rf_we;
    assign debug_wb_reg = instruction[11:7];
    assign debug_wb_value = WD;
    
    PC U_PC(
        .npc    (npc),
        .clk    (clk),
        .rst    (rst_n),
        .pc     (pc)
        );
    
    NPC U_NPC(
        .rst    (rst_n),
        .clk    (clk),
        .pc     (pc),
        .npc_op (npc_op),
        .sext   (sext),
        .branch (branch),
        .alu_c  (alu_c),
        .pc4    (pc4),
        .npc    (npc)
        );
        
    RF U_RF(
        .WR     (instruction[11:7]),
        .rR2    (instruction[24:20]),
        .rR1    (instruction[19:15]),
        .rf_we  (rf_we),
        .wd_sel (wd_sel),
        .clk    (clk),
        .rst    (rst_n),
        .alu_c  (alu_c),
        .dram   (dram),
        .pc4    (pc4),
        .R1     (rs1),
        .R2     (rs2),
        .WD     (WD)
        );
        
    SEXT U_SEXT(
        .sext_op    (sext_op),
        .din        (instruction),
        .sext       (sext)
        );
        
    ALU U_ALU(
        .A        (rs1),
        .rs2        (rs2),
        .alu_op     (alu_op),
        .B_op       (B_op),
        .sext       (sext),
        .alub_sel   (alub_sel),
        .alu_c      (alu_c),
        .branch     (branch)
        );
        
    control U_CONTROL(
        .opcode     (instruction[6:0]),
        .funct7     (instruction[31:25]),
        .funct3     (instruction[14:12]),
        .alu_op     (alu_op),
        .B_op       (B_op),
        .alub_sel   (alub_sel),
        .dram_we    (dram_we),
        .npc_op     (npc_op),
        .wd_sel     (wd_sel),
        .rf_we      (rf_we),
        .sext_op    (sext_op)
        );
        
// 64KB IROM
    inst_mem U0_irom (
        .a      (pc[15:2]),   // input wire [13:0] a
        .spo    (instruction)   // output wire [31:0] spo
    );

    // 64KB DRAM
    data_mem U_dram (
    .clk    (clk),            // input wire clka
    .a      (alu_c[15:2]),     // input wire [13:0] addra
    .spo    (dram),        // output wire [31:0] douta
    .we     (dram_we),          // input wire [0:0] wea
    .d      (rs2)         // input wire [31:0] dina
);



endmodule
