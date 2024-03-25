`include "param.v"
module ID(                               //��������ͼĴ�����
input clk_cpu,
input rst_cpu,
input [31:0]inst,                           //32λָ��
input [2:0] imm_sel,
input rd_we_wb,                                //�Ĵ�����дʹ��
input [31:0] data_wb,                       //�Ĵ�����д�������
input [4:0] rd_wb,
output [31:0] rD1_id,                       //rs1������
output [31:0] rD2_id,                       //rs2������
output [31:0] imm_id,                       //��չ���������
output [4:0] rs1_id,
output [4:0] rs2_id,
output [6:0] funct7,
output [2:0] funct3,
output [6:0] opcode,                         //�������control��Ԫ
output [4:0] rd_id
);

//����
assign rs1_id = inst[19:15];
assign rs2_id = inst[24:20];
assign funct7 = inst[31:25];
assign funct3 = inst[14:12];
assign opcode = inst[6:0];
assign rd_id = inst[11:7];

assign imm_id = imm_sel == `I ? {{20{inst[31]}},inst[31:20]} : 
            (imm_sel == `S ? {{20{inst[31]}},inst[31:25],inst[11:7]}: 
            (imm_sel == `B ? {{20{inst[31]}},inst[31],inst[7],inst[30:25],inst[11:8]}: 
            (imm_sel == `U ? {inst[31:12],12'b0}:
            {{20{inst[31]}},inst[31],inst[19:12],inst[20],inst[30:21]})));

reg[31:0] Register [31:0];
integer i;

always@(posedge clk_cpu or posedge rst_cpu)           //д��
begin
    if(rst_cpu)
    begin
        for(i = 0;i < 32;i = i + 1)
            Register[i] <= 0;                                  //�Ĵ�������0
    end
    else begin
    if(rd_we_wb == 1 && rd_wb != 0)
        begin
            Register[rd_wb] <= data_wb;                       //����д�ؼĴ�����
        end
    end
end
    

assign rD1_id = (rs1_id == 0) ? 0 : Register[rs1_id];
assign rD2_id = (rs2_id == 0) ? 0 : Register[rs2_id];        //��������Ĵ���������
endmodule
