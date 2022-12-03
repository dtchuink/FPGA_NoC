(* dont_touch="true" *) module DEMUX3
#(
  parameter DATA_PACKET_SIZE = 10
)
(
    input clk,
	 input reset,
    input [(DATA_PACKET_SIZE-1):0] data_1,
	input [1:0] select,
	 
	 output  reg [(DATA_PACKET_SIZE-1):0] out_1,
	 output  reg [(DATA_PACKET_SIZE-1):0] out_2,
	 output  reg [(DATA_PACKET_SIZE-1):0] out_3
);


 always@(posedge clk)
 begin
  if(reset)
	   begin
		  out_1 <= 'bz;
		  out_2 <= 'bz;
		  out_3 <= 'bz;
		end  
   else	
    begin	
		  if(select==2'b0)
			  out_1 <= data_1;	  
		  else
		   if(select==2'b1) 
            out_2 <= data_1;
			else	
		    if(select==2'b10)
			    out_3 <= data_1;
			 else
		      begin
				  out_1 <= 'bz;
				  out_2 <= 'bz;
				  out_3 <= 'bz;
				end	 
 	 end 	
 	 
 end
 
endmodule 
