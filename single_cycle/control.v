`include "param.v"
module control(
input [6:0]opcode,
input [6:0]funct7,
input [2:0]funct3,
output reg [3:0]alu_op,
output reg [2:0]B_op,
output reg alub_sel,
output reg dram_we,
output reg [1:0]npc_op,
output reg [1:0]wd_sel,
output reg rf_we,
output reg [3:0]sext_op
    );
    
    always@(*) begin
        case(opcode)
            `R_type: begin
                            npc_op = `PLUS_4;
                            rf_we = 1;  //写回
                            wd_sel = 1;
                            B_op = 0;
                            alub_sel = 1;
                            dram_we = 0;
                            case(funct7)
                                7'b0000000: begin
                                                case(funct3)
                                                    3'b000:alu_op = `ADD;
                                                    3'b111:alu_op = `AND;
                                                    3'b110:alu_op = `OR;
                                                    3'b100:alu_op = `XOR;
                                                    3'b001:alu_op = `SLL;
                                                    3'b101:alu_op = `SRL;
                                                endcase    
                                            end
                                7'b0100000: begin
                                                case(funct3)
                                                    3'b000:alu_op = `SUB;
                                                    3'b101:alu_op = `SRA;
                                                endcase    
                                            end
                            endcase
                        end
            `I_type: begin
                            npc_op = `PLUS_4;
                            rf_we = 1;
                            wd_sel = 1;
                            sext_op = 0;
                            B_op = 0;
                            alub_sel = 0;
                            dram_we = 0;
                            case(funct3)
                                3'b000:alu_op = `ADD;   //addi  
                                3'b111:alu_op = `AND;   //andi
                                3'b110:alu_op = `OR;    //ori
                                3'b100:alu_op = `XOR;   //xori
                                3'b001:alu_op = `SLL;   //slli
                                3'b101: begin
                                            if(funct7[5] == 0) alu_op = `SRL;   //srli
                                            else alu_op = `SRA; //srai
                                        end
                            endcase
                        end    
            `I_type_lw: begin   //lw
                            npc_op = `PLUS_4;
                            rf_we = 1;
                            wd_sel = 2;
                            sext_op = 0;
                            B_op = 0;
                            alub_sel = 0;
                            dram_we = 0;
                            alu_op = 0; //add计算地址到dram
                        end
            `I_type_jalr: begin //jalr
                            npc_op = `JUMP_R;
                            rf_we = 1;  //写回pc+4
                            wd_sel = 0;
                            sext_op = 0;
                            B_op = 0;
                            dram_we = 0;
                            alu_op = 0;
                        end
             `S_type: begin //sw
                            npc_op = `PLUS_4;
                            rf_we = 0;      //无写回
                            sext_op = 1;   
                            B_op = 0;
                            alub_sel = 0;   //add计算读取地址
                            dram_we = 1;
                            alu_op = 0;
                        end
            `B_type: begin  
                            npc_op = `BRANCH;
                            rf_we = 0;      //无写回
                            sext_op = 2;
                            alub_sel = 1;   //sub判断大小
                            dram_we = 0;
                            alu_op = 1;
                            case(funct3)
                                 3'b000:B_op = `EQUAL;  //beq
                                 3'b001:B_op = `UNEQUAL;//bne
                                 3'b100:B_op = `LESS;   //blt
                                 3'b101:B_op = `GREATER;//bge
                            endcase
                         end
            `U_type: begin  //lui
                            npc_op = `PLUS_4;
                            rf_we = 1;      //写回结果
                            wd_sel = 1;
                            sext_op = 3;
                            B_op = 0;
                            alub_sel = 0;
                            dram_we = 0;
                            alu_op = 8;
                         end   
            `J_type: begin  //jal
                            npc_op = `JUMP;
                            rf_we = 1;      //写回pc+4
                            wd_sel = 0;
                            sext_op = 4;
                            B_op = 0;
                            dram_we = 0;            
                         end   
            default: npc_op = `PLUS_4;                                                              
            endcase
        end
endmodule
