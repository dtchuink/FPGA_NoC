(* dont_merge *) module MUX2
#(
  parameter DATA_PACKET_SIZE = 10
)
(
    input clk,
	 input reset,
    input [(DATA_PACKET_SIZE-1):0] data_1,
	 input [(DATA_PACKET_SIZE-1):0] data_2,
	 input select,
	 
	 output reg [(DATA_PACKET_SIZE-1):0] out
);

// assign out = (!select)?data_1:data_2; //if select==0 data_1 -> out, if select==1 data_2 -> out
 
 
//assign out = reset?'bz:( (!select)?data_1:data_2   ); 
 
 always@(posedge clk)
 begin
   if(reset)
	   out <='bz;
   else
    begin	
		  if(select==0)
			  out <= data_1;
		  else
		   if(select)  
			  out <= data_2;
			else
	     	 out <='bz;
 	 end 
 end

endmodule 
