

module IF_ID(
input clk_cpu,
input rst_cpu,
input [31:0] pc_if,
input [31:0] inst_if,
input flush,
input stop,
output reg[31:0] pc_id,
output reg[31:0] inst_id
);

always@(posedge clk_cpu or posedge rst_cpu)
begin
    if(rst_cpu)
    begin
        inst_id <= 0;
        pc_id <= 32'hffff_fffc;
    end
    else if(stop)begin                             //ͣ��
        inst_id <= inst_id;
        pc_id <= pc_id;
    end                               
    else if(flush) begin                           //��֧Ԥ��
        inst_id <= 0;
        pc_id <= 32'hffff_fffc;
    end
    else begin                                    //���쳣���
        pc_id <= pc_if;
        inst_id <= inst_if;
    end
end
endmodule
