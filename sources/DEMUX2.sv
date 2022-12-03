(* dont_merge *) module DEMUX2
#(
  parameter DATA_PACKET_SIZE = 10
)
(//based on the router "RANK" field we know the direction to choose
    input clk,
	 input reset,
    input [(DATA_PACKET_SIZE-1):0] data_1,
	 input select,
	 
	 output  reg [(DATA_PACKET_SIZE-1):0] out_1,
	 output  reg [(DATA_PACKET_SIZE-1):0] out_2
);

// assign out_1 = !select?data_1:'bz; //if select==0 data_1 -> out_1
// assign out_2 = select?data_1:'bz; //if select==1 data_1 -> out_2

 always@(posedge clk)
 begin
  if(reset)
	   begin
		  out_2 <= 'bz;
		  out_1 <= 'bz;
		end  
   else	
    begin	
	  if(!select)
		begin
		  //out_2 <= 0;
		  out_1 <= data_1;
		end		
	  else
	    if(select)
			begin
			 // out_1 <= 0;
			  out_2 <= data_1;
			end
		 else
		  begin
		   out_2 <= 'bz;
		   out_1 <= 'bz;
		  end 
	 end	
 	 
 end
 
endmodule 
