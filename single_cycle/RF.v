
module RF(
input [4:0]WR,
input [4:0]rR2,
input [4:0]rR1,
input rf_we,
input [1:0]wd_sel,
input clk,
input rst,
input [31:0]alu_c,
input [31:0]dram,
input [31:0]pc4,
output reg [31:0]R1,
output reg [31:0]R2,
output reg [31:0]WD
    );
    
    reg [31:0]rf[0:31];
    integer i = 0;
    
    always@(*) begin    //wd¶àÂ·Ñ¡ÔñÆ÷
        case(wd_sel)
            0: WD = pc4;
            1: WD = alu_c;
            2: WD = dram;
            default: WD = 32'b0;
        endcase    
        R1 = rf[rR1];
        R2 = rf[rR2];
    end
    
    always@(posedge clk or negedge rst) begin   //RF¼Ä´æÆ÷¶Ñ
        if(!rst) begin
            for (i = 0; i <= 31; i = i + 1)
                begin
                    rf[i] <= 0;
                end
        end
        if(rf_we == 1 && WR != 0) 
            rf[WR] <= WD;
        else
            rf[WR] <= rf[WR];
    end
    
endmodule
