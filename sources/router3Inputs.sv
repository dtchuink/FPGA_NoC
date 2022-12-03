(* dont_touch="true" *) 
module router3Input
#(
  parameter RANK = 2,
  parameter DATA_PACKET_SIZE = 32,
  parameter RANK_BEGIN = 5,
  parameter RANK_END = 8,
  parameter VR_ID = 9,
  parameter FIFO_DEPTH = 4
)
(
  input clk_rtr,
 // input clk_vr,
  
  input reset,
  
  //connection with other routers
  bus.source north_src,
  bus.sink north_sink,
  
  bus.source east_src,
  bus.sink east_sink,
  
  bus.source west_src,
  bus.sink west_sink
);

wire select_mux1, select_mux2, select_mux3;

switchbox3Input 
#(
  .RANK(RANK),
  .DATA_PACKET_SIZE(DATA_PACKET_SIZE),
  .RANK_BEGIN(RANK_BEGIN),
  .RANK_END(RANK_END),
  .VR_ID(VR_ID),
  .FIFO_DEPTH(FIFO_DEPTH)
)
SW3
(
	.clk_rtr(clk_rtr) ,	
	//.clk_vr(clk_vr),
	.reset(reset) ,
	
	.data_in1(west_sink.valid),
	.data_in2(east_sink.valid),
	.data_in3(north_sink.valid),
	
	.in1(west_sink.data) , 
	.in2(east_sink.data) , 
	.in3(north_sink.data) , 
	
	.out1(west_src.data) , 
	.out2(east_src.data) ,
	.out3(north_src.data),
	
	.sink_ready1(west_sink.ready),
	.sink_ready2(east_sink.ready),
	.sink_ready3(north_sink.ready),
	
	.target_ready1(west_src.ready),
	.target_ready2(east_src.ready),
	.target_ready3(north_src.ready),
	
	.select_mux1_out(select_mux1),
   .select_mux2_out(select_mux2),
   .select_mux3_out(select_mux3)
);



always@(posedge clk_rtr)//we create flip-flops to decide when to valid data
begin
  if(reset)
   begin
	  north_src.valid <= 0;
     west_src.valid <= 0;
     east_src.valid <= 0;
	end
  else
   begin
	  if(west_src.ready)//for the west
	   begin
	    if(select_mux1 == 0 || select_mux1 == 1 )
	      west_src.valid <= 1;
		 else	
	      west_src.valid <= 0;
		end
	  else
	    west_src.valid <= 0;
	 
	 
	   if(east_src.ready)//for the east
	   begin
	    if(select_mux2 == 0 || select_mux2 == 1)
	      east_src.valid <= 1;
		 else	
	      east_src.valid <= 0;
		end
	  else
	    east_src.valid <= 0;
	
	
	  if(north_src.ready)//for the south/north
	   begin
	    if(select_mux3 == 0 || select_mux3 == 1)
	      north_src.valid <= 1;
		 else	
	      north_src.valid <= 0;
		end
	  else
	    north_src.valid <= 0; 
	  
   end
end


endmodule 
