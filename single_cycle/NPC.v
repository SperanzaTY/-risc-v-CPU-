
`include "param.v"

module NPC(
input rst,
input clk,
input [31:0]pc,
input [1:0]npc_op,
input [31:0]sext,
input branch,
input [31:0]alu_c,
output  reg [31:0]pc4,
output  reg [31:0]npc
    );
    
    always@(*) begin
        if(!rst) begin
            pc4 = 'hfffffffc;
            npc = 'h00000000;
            end
        else begin    
            pc4 = pc + 4; 
            case(npc_op)
            `PLUS_4: npc = pc + 4;
            `BRANCH: if ( branch == 0 ) npc = pc + 4;
                   else npc = pc + sext;
            `JUMP: npc = pc + sext;   //jal
            `JUMP_R: npc = alu_c & 'hfffffffe;         //jalr 最后一位清零
            endcase
        end
    end

endmodule