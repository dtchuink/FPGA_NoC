module MUX3
#(
  parameter DATA_PACKET_SIZE = 10
)
(
    input clk,
	 input reset,
    input [(DATA_PACKET_SIZE-1):0] data_1,
	 input [(DATA_PACKET_SIZE-1):0] data_2,
	 input [(DATA_PACKET_SIZE-1):0] data_3,
	 input [1:0]select,
	 
	 output reg [(DATA_PACKET_SIZE-1):0] out
);


always@(posedge clk)
 begin
   if(reset)
	   out <='bz;
   else
    begin	
		  if(select==2'b0)
			  out <= data_1;	  
		  else
		   if(select==2'b1) 
            out <= data_2;
			else	
		    if(select==2'b10)
			    out <= data_3;
			 else	 
				 out <='bz;
 	 end 
 end

endmodule 
