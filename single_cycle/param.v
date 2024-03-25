
`ifndef CPU_PARAM
`define CPU_PARAM
//opcode
`define R_type 7'b0110011
`define I_type 7'b0010011
`define I_type_lw 7'b0000011
`define I_type_jalr 7'b1100111
`define S_type 7'b0100011
`define B_type 7'b1100011
`define U_type 7'b0110111
`define J_type 7'b1101111

//sext_op
`define I_type_ext 3'd0
`define S_type_ext 3'd1
`define B_type_ext 3'd2
`define U_type_ext 3'd3
`define J_type_ext 3'd4


//ALU_op
`define ADD 4'd0
`define SUB 4'd1
`define AND 4'd2
`define OR 4'd3
`define XOR 4'd4
`define SLL 4'd5
`define SRL 4'd6
`define SRA 4'd7
`define SAME 4'd8

//npc_op
`define PLUS_4 2'b00
`define BRANCH 2'b01
`define JUMP 2'b10
`define JUMP_R 2'b11

//B_op
`define OTHER 'd0
`define EQUAL 'd1
`define UNEQUAL 'd2
`define LESS 'd3
`define GREATER 'd4

`endif