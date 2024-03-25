

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
    else if(stop)begin                             //停顿
        inst_id <= inst_id;
        pc_id <= pc_id;
    end                               
    else if(flush) begin                           //分支预测
        inst_id <= 0;
        pc_id <= 32'hffff_fffc;
    end
    else begin                                    //无异常情况
        pc_id <= pc_if;
        inst_id <= inst_if;
    end
end
endmodule
