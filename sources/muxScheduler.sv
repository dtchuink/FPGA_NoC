module muxScheduler(
  input clk,
  input reset,
  
  input port0_dataIN,
  input port1_dataIN,
  
  output reg select
);

reg counter = 1'b0;

always@(posedge clk)
begin
//  if(reset)
//    select <= 1'bz;
//  else	 
//   begin
	  if(port0_dataIN == 0  && port1_dataIN == 0) //no data packet to forward
			 select <= 1'bz;
			 
	  if(port0_dataIN == 0  && port1_dataIN == 1) 
			 select <= 1'b1; 	
			 
	  if(port0_dataIN == 1  && port1_dataIN == 0) 
			 select <= 1'b0; 

		if(port0_dataIN == 1  && port1_dataIN == 1) 
			 select <= counter;  		 
//   end
end



always@(posedge clk)
begin
  if(reset)
    counter <= 1'b0;
  else
    begin 
	   counter <= !counter;
  
    end
end


endmodule 
