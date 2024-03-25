

module IF(
input clk_cpu,
input rst_cpu,
input stop,
input pc_sel,
input npc_sel,
input [31:0]pc_imm,//B J
input [31:0]res_alu,              //alu�����ĵ�ַ
output [31:0]inst,
output reg [31:0]pc
);

// PC��Ԫ
always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu) 
        pc <= 32'hffff_fffc;       //��λʱpc=-4
    else if(stop)
        pc <= pc;                   //ͣ��
    else if(pc_sel == 'b1) 
        pc <= (res_alu & (~1));      //jalr
    else if(npc_sel == 'b1) 
        pc <= pc_imm;
    else 
        pc <= pc + 4;
end

//IROM��Ԫ
inst_mem IROM (
  .a(pc[15:2]),      // input wire [13 : 0] a
  .spo(inst[31:0])  // output wire [31 : 0] spo
);
endmodule
