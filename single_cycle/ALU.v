`include "param.v"

module ALU(
input [31:0]A,
input [31:0]rs2,
input [3:0]alu_op,
input [2:0]B_op,
input [31:0]sext,
input alub_sel,
output reg [31:0]alu_c,
output reg branch
    );
    
    reg [31:0]B;
    
    always@(*) begin    //B输入多路选择器
        if(alub_sel == 1) B = rs2;
        else B = sext; 
    end
    
    always@(*) begin    //ALU
        case (alu_op)
            `ADD: alu_c = A + B;                       //ADD
            `SUB: begin                                   //SUB
                alu_c = A - B;
                case(B_op)
                    `OTHER : branch = 0;
                    `EQUAL: if(alu_c == 0) branch = 1;
                       else branch = 0;
                    `UNEQUAL: if(alu_c == 0) branch = 0;
                       else branch = 1;
                    `LESS: if(alu_c[31] == 1) branch = 1;
                       else branch = 0;
                    `GREATER: if(alu_c[31] == 1) branch = 0;
                       else branch = 1;
                endcase
               end
            `AND: alu_c = A & B;                       //AND
            `OR: alu_c = A | B;                       //OR
            `XOR: alu_c = A ^ B;                       //XOR
            `SLL: begin                                   //SLL
                alu_c = B[0] ? {A[30:0],1'b0} : A;
                alu_c = B[1] ? {alu_c[29:0],2'b0} : alu_c;
                alu_c = B[2] ? {alu_c[27:0],4'b0} : alu_c;
                alu_c = B[3] ? {alu_c[23:0],8'b0} : alu_c;
                alu_c = B[4] ? {alu_c[15:0],16'b0} : alu_c;
                alu_c = B[5] ? 32'b0 : alu_c;
               end
            `SRL: begin                                   //SRL
                alu_c = B[0] ? {1'b0,A[31:1]} : A;
                alu_c = B[1] ? {2'b0,alu_c[31:2]} : alu_c;
                alu_c = B[2] ? {4'b0,alu_c[31:4]} : alu_c;
                alu_c = B[3] ? {8'b0,alu_c[31:8]} : alu_c;
                alu_c = B[4] ? {16'b0,alu_c[31:16]} : alu_c;
                alu_c = B[5] ? 32'b0 : alu_c;
               end
            `SRA: begin                                   //SRA
                    alu_c = B[0] ? {A[31],A[31:1]} : A;
                    alu_c = B[1] ? {{2{alu_c[31]}},alu_c[31:2]} : alu_c;
                    alu_c = B[2] ? {{4{alu_c[31]}},alu_c[31:4]} : alu_c;
                    alu_c = B[3] ? {{8{alu_c[31]}},alu_c[31:8]} : alu_c;
                    alu_c = B[4] ? {{16{alu_c[31]}},alu_c[31:16]} : alu_c;
                    alu_c = B[5] ? {32{alu_c[31]}} : alu_c;
                end
            `SAME: alu_c = B;                              //SAME
        endcase
    end    

endmodule
