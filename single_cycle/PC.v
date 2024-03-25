
module PC(
input [31:0]npc,
input clk,
input rst,
output reg [31:0]pc
    );    
    always@(posedge clk or negedge rst) begin
        if(!rst) pc <= 32'hfffffffc;    //¼Ó4ºó¹éÁã
        else pc <= npc;
        end
endmodule
