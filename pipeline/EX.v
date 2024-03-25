`include "param.v"

module EX(
input rst_cpu,
input [31:0]pc_ex,
input [31:0]rD1_ex, 
input [31:0]rD2_ex,
input [31:0]imm_ex,
input [2:0]alu_sel_ex,
input [2:0]branch_ex,
input rs2_sel_ex,   //选择信号
output reg [31:0]res_ex,
output [31:0]pc_imm_ex,
output reg flush,
output reg pc_sel,
output reg npc_sel
);

reg [1:0]flag_branch;
wire signed [31:0]data2;
wire signed [31:0]data1;
wire signed [31:0]res_sub;
assign data2 = (rs2_sel_ex == 1'b1 ? imm_ex : rD2_ex);
assign data1 = rD1_ex;
assign res_sub = data1 + (~data2 + 1);  //有符号数减法
 
always@(*) begin                                                          //alu模块
    if(alu_sel_ex == `add)      res_ex = data1 + data2;
    else if(alu_sel_ex == `sub) res_ex = data1 + ~data2 + 1;
    else if(alu_sel_ex == `and) res_ex = data1 & data2;
    else if(alu_sel_ex == `or)  res_ex = data1 | data2;
    else if(alu_sel_ex == `xor) res_ex = data1 ^ data2;
    else if(alu_sel_ex == `sll) res_ex = (data1 << data2[4:0]);
    else if(alu_sel_ex == `srl) res_ex = (data1 >> data2[4:0]);
    else if(alu_sel_ex == `sra) res_ex = (data1 >>> data2[4:0]);
    else res_ex = 0;
    //两数比较
    if(res_sub == 0) flag_branch = `equal;
    else if(res_sub < 0) flag_branch = `less;
    else if(res_sub > 0) flag_branch = `greater;
    else flag_branch = 0;
end

//pc+imm
assign pc_imm_ex = pc_ex + (imm_ex << 1);

always@(*) begin                                                      //分支预测
    if(rst_cpu)
        flush = 'b0;
    else if(branch_ex == 3'b101)                                    //jal，跳转
        flush = 'b1;                                                
    else if(branch_ex == 3'b110)                                    //jalr，跳转
        flush = 'b1;                                               
    else if(branch_ex == 3'b001 && flag_branch == `equal)           //beq指令，相等跳转
        flush = 'b1;
    else if(branch_ex == 3'b010 && flag_branch != `equal)           //bne指令，不相等跳转
        flush = 'b1;
    else if(branch_ex == 3'b011 && (flag_branch == `equal || flag_branch == `greater))        //bge指令，大于/等于跳转
        flush = 'b1;
    else if(branch_ex == 3'b100 && flag_branch == `less)            //blt指令，小于跳转
        flush = 'b1;
    else
        flush = 'b0;
end

always@(*)
begin
    if(rst_cpu)
    begin
        pc_sel = 'b0;
        npc_sel = 'b0;
    end
    else if(branch_ex == 3'b101)
    begin
        pc_sel = 'b0;
        npc_sel = 'b1;
    end
    else if(branch_ex == 3'b110)
    begin
        pc_sel = 'b1;
        npc_sel = 'b0;
    end
    else if(branch_ex == 3'b001 && flag_branch == `equal)
    begin
        pc_sel = 'b0;
        npc_sel = 'b1;
    end
    else if(branch_ex == 3'b010 && flag_branch != `equal)
    begin
        pc_sel = 'b0;
        npc_sel = 'b1;
    end
    else if(branch_ex == 3'b011 && (flag_branch == `equal || flag_branch== `greater))
        begin
        pc_sel = 'b0;
        npc_sel = 'b1;
    end
    else if(branch_ex == 3'b100 && flag_branch == `less)
        begin
        pc_sel = 'b0;
        npc_sel = 'b1;
    end
    else
        begin
        pc_sel = 'b0;
        npc_sel = 'b0;
    end    
end
endmodule
