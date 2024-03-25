`include "param.v"

module SEXT(
input [3:0]sext_op,
input [31:0]din,
output reg [31:0]sext
    );
//立即数生成
    always@(*) begin
        case (sext_op)  //符号位拓展
            `I_type_ext: sext = {{20{din[31]}},din[31:20]}; 
            `S_type_ext: sext = {{20{din[31]}},din[31:25],din[11:7]};
            `B_type_ext: sext = {{19{din[31]}},din[31],din[7],din[30:25],din[11:8],1'b0};
            `U_type_ext: sext = {din[31:12],12'b000000000000};
            `J_type_ext: sext = {{11{din[31]}},din[31],din[19:12],din[20],din[30:21],1'b0};
            default: sext = 32'b0;
        endcase
    end 
endmodule
