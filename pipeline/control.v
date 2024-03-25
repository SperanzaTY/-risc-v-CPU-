`include "param.v"

module control(
input rst_cpu,
input [6:0] opcode,
input [2:0] funct3,
input [6:0] funct7,
output reg [2:0] branch,
output reg [2:0] imm_sel,
output reg [1:0] wd_sel,
output reg rd_we,
output reg [2:0] alu_sel,
output reg rs2_sel,
output reg dram_we,
output reg id_re
    );
    
always@(*) begin
    if(rst_cpu)
        imm_sel = 0;
    else if(opcode == 7'b001_0011 || opcode == 7'b000_0011 || opcode == 7'b110_0111)
        imm_sel = `I;
    else if(opcode == 7'b010_0011)
        imm_sel = `S;
    else if(opcode == 7'b110_0011)
        imm_sel = `B;
    else if(opcode == 7'b011_0111)
        imm_sel = `U;
    else if(opcode == 7'b110_1111)
        imm_sel = `J;
    else 
        imm_sel = 0;
end   
    
always@(*) begin
    if(opcode == 7'b001_0011 || opcode == 7'b011_0011)
        wd_sel = `alu;                                              //R或I
    if(opcode == 7'b000_0011)  
        wd_sel = `dram;                                             //lw
    else if(opcode == 7'b011_0111) 
        wd_sel = `imm;                                              //lui
    else if(opcode == 7'b110_1111 || opcode == 7'b110_0111) 
        wd_sel = `pc4;                                              //jal或jalr
    else 
        wd_sel = 0;
end

always@(*)
begin 
    if(rst_cpu) 
        branch = 0;
    else if(opcode == 7'b110_1111)
        branch = 3'b101;                //jal
    else if(opcode == 7'b110_0111) 
        branch = 3'b110;               //jalr
    else if(opcode == 7'b110_0011)
        begin
            if(funct3 == 3'b000) 
                branch = 3'b001;                   //beq
            else if(funct3 == 3'b101) 
                branch = 3'b011;             //bge
            else if(funct3 == 3'b001) 
                branch = 3'b010;             //bne
            else if(funct3 == 3'b100) 
                branch = 3'b100;             //blt
            else 
                branch = 3'b000;
        end
    else branch = 3'b000;
end


always@(*)
begin
    if(rst_cpu)id_re = 0;
    else if(opcode == 7'b110_1111 || opcode == 7'b011_0111)id_re = 0;//U J
    else id_re = 1;
end


always@(*) begin
    if(rst_cpu)
        rd_we = 1'b0;
    else if(opcode == 7'b011_0011 || opcode == 7'b001_0011) 
        rd_we = 1'b1;                                   //R、I
    else if(opcode == 7'b000_0011 || opcode ==  7'b110_0111 || opcode == 7'b110_1111)
        rd_we = 1'b1;                                   //lw,jalr,jal
    else if(opcode == 7'b011_0111) 
        rd_we = 1'b1;                                  //lui
    else 
        rd_we = 1'b0;
end

always@(*) begin
    if(opcode ==  7'b011_0011) begin
        if(funct3 == 3'b000 && funct7 == 7'b000_0000)            alu_sel = `add;
        else if(funct3 == 3'b000 && funct7 == 7'b010_0000)       alu_sel = `sub;
        else if(funct3 == 3'b001 && funct7 == 7'b000_0000)       alu_sel = `sll;
        else if(funct3 == 3'b100 && funct7 == 7'b000_0000)       alu_sel = `xor;
        else if(funct3 == 3'b101 && funct7 == 7'b000_0000)       alu_sel = `srl;
        else if(funct3 == 3'b101 && funct7 == 7'b010_0000)       alu_sel = `sra;
        else if(funct3 == 3'b110 && funct7 == 7'b000_0000)       alu_sel = `or;
        else if(funct3 == 3'b111 && funct7 == 7'b000_0000)       alu_sel = `and;
        else alu_sel = 0;
        end
     else if(opcode == 7'b001_0011) begin
        if(funct3 == 3'b000)                                     alu_sel = `add;
        else if(funct3 == 3'b001)                                alu_sel = `sll;
        else if(funct3 == 3'b100)                                alu_sel = `xor;
        else if(funct3 == 3'b101 && funct7 == 7'b000_0000)       alu_sel = `srl;
        else if(funct3 == 3'b101 && funct7 == 7'b010_0000)       alu_sel = `sra;
        else if(funct3 == 3'b110)                                alu_sel = `or;
        else if(funct3 == 3'b111)                                alu_sel = `and;
        else alu_sel = 0;
     end
     else if(opcode == 7'b000_0011)                              alu_sel = `add;//lw
     else if(opcode == 7'b110_0111)                              alu_sel = `add;//jalr
     else if(opcode == 7'b010_0011)                              alu_sel = `add; //sw
     else if(opcode == 7'b110_0011)                              alu_sel = `sub;//B型
end

always@(*) begin
    if(opcode == 7'b011_0011)                                    
        rs2_sel = 1'b0;
    else if(opcode == 7'b110_0011) 
        rs2_sel = 1'b0;
    else 
        rs2_sel = 1'b1;     //非R和B型指令
    
end

//dram_we
always@(*) begin
    if(opcode == 7'b010_0011)
        dram_we = 1'b1;
    else 
        dram_we = 1'b0;
end




endmodule
