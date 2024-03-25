`include "param.v"
module hazard(
input clk_cpu,
input rst_cpu,
input [4:0]rs1_id,
input [4:0]rs2_id,
input [1:0]wd_sel_ex,
input [4:0]rd_ex,
input [4:0]rd_mem,//pc + 4,imm,alu,dmem
input rd_we_ex,          
input id_re,
input rd_we_mem,
input [4:0]rd_wb,
input rd_we_wb,
output reg [2:0]rD1_sel,
output reg [2:0]rD2_sel,
output reg stop
    );
    
 reg flag_stop;
    always@(posedge clk_cpu or posedge rst_cpu)
    begin
        if(rst_cpu)
            flag_stop <= 1;
        else if(stop) 
            flag_stop <= 0;     
        else 
            flag_stop <= 1;
    end

always@(*)
begin
	if(rst_cpu == 1)
		rD1_sel = 0;
	else if(rs1_id == rd_ex && rd_we_ex && id_re && rd_ex != 0 && flag_stop) 
		begin if(wd_sel_ex == `alu )
			rD1_sel = 'b001 ;
			else
			rD1_sel = 'b010 ;
		end
	else if(rs1_id == rd_mem && rd_we_mem && id_re && rd_mem != 0)
		rD1_sel = 'b011 ;
	else if(rs1_id == rd_wb && rd_we_wb && id_re && rd_wb != 0)
		rD1_sel = 'b100 ;
	else 	rD1_sel = 'b000 ;
end
		 
always@(*)
begin
	if(rst_cpu == 1)
		rD2_sel = 0;
	else if(rs2_id == rd_ex && rd_we_ex && id_re && rd_ex != 0 && flag_stop) 
		begin if(wd_sel_ex == `alu )
			rD2_sel = 'b001 ;
			else
			rD2_sel = 'b010 ;
		end
	else if(rs2_id == rd_mem && rd_we_mem && id_re && rd_mem != 0)
		rD2_sel = 'b011 ;
	else if(rs2_id == rd_wb && rd_we_wb && id_re && rd_wb != 0)
		rD2_sel = 'b100 ;
	else 	rD2_sel = 'b000 ;
end

always@(*)
begin		
	if(rst_cpu == 1)
		stop = 0;
	else if(flag_stop && (rs1_id == rd_ex || rs2_id == rd_ex) && rd_we_ex && id_re && wd_sel_ex == `dram)
		stop = 1;
	else	stop = 0;
end
	
endmodule


