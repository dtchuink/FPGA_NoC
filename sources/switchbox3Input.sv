//import constants::*;
(* dont_touch="true" *) 
module switchbox3Input 
#(
  parameter RANK = 2,
  parameter DATA_PACKET_SIZE = 10,
  parameter RANK_BEGIN = 5,
  parameter RANK_END = 8,
  parameter VR_ID = 9,
  parameter FIFO_DEPTH = 4
)
(
  input clk_rtr,
  input clk_vr,
  
  input reset,
 
  input data_in1,
  input data_in2,
  input data_in3,
  
  input target_ready1, //we only retrieve from FIFO when the destination target is ready to receive (its FIFO aren't full)
  input target_ready2,
  input target_ready3,
  
  input [(DATA_PACKET_SIZE-1):0] in1,
  input [(DATA_PACKET_SIZE-1):0] in2,
  input [(DATA_PACKET_SIZE-1):0] in3,
  
 
  output [(DATA_PACKET_SIZE-1):0] out1,
  output [(DATA_PACKET_SIZE-1):0] out2,
  output [(DATA_PACKET_SIZE-1):0] out3,
  
  
  output sink_ready1, //ready to receive data when FIFOs aren't full
  output sink_ready2,
  output sink_ready3,
  
  output reg select_mux1_out,//allows to know when we are ready to transmit data out
  output reg select_mux2_out,
  output reg select_mux3_out
  
 
 
);

reg data_in3_out;

reg select_demux1, select_demux2, select_demux3;
wire select_mux1, select_mux2, select_mux3;

wire [(DATA_PACKET_SIZE-1):0] demux_in1_out1, demux_in1_out2, demux_in2_out1, demux_in2_out2, demux_in3_out1, demux_in3_out2;

wire fifo1_mux_ch1_empty, fifo2_mux_ch1_empty, fifo1_mux_ch2_empty,fifo2_mux_ch2_empty, fifo1_mux_ch3_empty,fifo2_mux_ch3_empty;
wire fifo2_mux_ch3_full,fifo1_mux_ch3_full,fifo2_mux_ch2_full, fifo1_mux_ch2_full,fifo2_mux_ch1_full,fifo1_mux_ch1_full;

wire [(DATA_PACKET_SIZE-1):0] fifo1_mux_ch1_DATA,fifo2_mux_ch1_DATA, fifo1_mux_ch2_DATA,fifo2_mux_ch2_DATA,fifo1_mux_ch3_DATA,fifo2_mux_ch3_DATA;	



//assign select_demux1 = data_in1?((in1[RANK_END:RANK_BEGIN] == RANK)?0:1):1'bz;//either we forward to the next router or to the other VR
//assign select_demux2 = data_in2?((in2[RANK_END:RANK_BEGIN]== RANK)?0:1):1'bz;//either we forward to the next router or to the other VR
//assign select_demux3 = data_in3?in3[VR_ID]:1'bz;//either we forward between the 2 VRs

//assign testOut1 = fifo1_mux_ch3_DATA;
//assign testOut2 = fifo2_mux_ch3_DATA;
//assign testOut3 = select_mux3;
////assign testOut4 = fifo2_mux_ch3_empty;

    assign sink_ready1 = 1;
    assign sink_ready2 = 1;
    assign sink_ready3 = 1;
   /***************************************************************/
  /*                       DEMUX CHANNELS                        */
 /***************************************************************/

//DEMUX CHANNEL 1
DEMUX2 #(.DATA_PACKET_SIZE(DATA_PACKET_SIZE)) DEMUX2_CH1
		(
			.clk(clk_rtr),
			.reset(reset),
			.data_1(in1) ,	// input [DATA_PACKET_SIZE-1:0] data_1_sig
			.select(select_demux1) ,	// input  select_sig
			.out_1(demux_in1_out1) ,	// output [DATA_PACKET_SIZE-1:0] out_1_sig
			.out_2(demux_in1_out2) 	// output [DATA_PACKET_SIZE-1:0] out_2_sig
		);


		
//DEMUX CHANNEL 2	
DEMUX2 #(.DATA_PACKET_SIZE(DATA_PACKET_SIZE)) DEMUX2_CH2
(
   .clk(clk_rtr),
	.reset(reset),
	.data_1(in2) ,	// input [DATA_PACKET_SIZE-1:0] data_1_sig
	.select(select_demux2) ,	// input  select_sig
	.out_1(demux_in2_out1) ,	// output [DATA_PACKET_SIZE-1:0] out_1_sig
	.out_2(demux_in2_out2) 	// output [DATA_PACKET_SIZE-1:0] out_2_sig
);

//DEMUX CHANNEL 3
DEMUX2 #(.DATA_PACKET_SIZE(DATA_PACKET_SIZE)) DEMUX2_CH3
(
	.clk(clk_rtr),
	.reset(reset),
	.data_1(in3) ,	// input [DATA_PACKET_SIZE-1:0] data_1_sig
	.select(select_demux3) ,	// input  select_sig
	.out_1(demux_in3_out1) ,	// output [DATA_PACKET_SIZE-1:0] out_1_sig
	.out_2(demux_in3_out2) 	// output [DATA_PACKET_SIZE-1:0] out_2_sig
);	
		

   /***************************************************************/
  /*                       MUX CHANNELS                          */
 /***************************************************************/
		
				
//MUX CHANNEL 1
MUX2 #(.DATA_PACKET_SIZE(DATA_PACKET_SIZE)) MUX2_CH1
(
   .clk(clk_rtr),
	.reset(reset),
	.data_1(demux_in2_out1) ,	// input [DATA_PACKET_SIZE-1:0] data_1_sig
	.data_2(demux_in3_out1) ,	// input [DATA_PACKET_SIZE-1:0] data_2_sig
	.select(select_mux1) ,	// input  select_sig
	.out(out1) 	// output [DATA_PACKET_SIZE-1:0] out_sig
);

//MUX CHANNEL 2
MUX2 #(.DATA_PACKET_SIZE(DATA_PACKET_SIZE)) MUX2_CH2
(
   .clk(clk_rtr),
	.reset(reset),
	.data_1(demux_in1_out1) ,	// input [DATA_PACKET_SIZE-1:0] data_1_sig
	.data_2(demux_in3_out2) ,	// input [DATA_PACKET_SIZE-1:0] data_2_sig
	.select(select_mux2) ,	// input  select_sig
	.out(out2) 	// output [DATA_PACKET_SIZE-1:0] out_sig
);

//MUX CHANNEL 3
MUX2 #(.DATA_PACKET_SIZE(DATA_PACKET_SIZE)) MUX2_CH3
(
   .clk(clk_rtr),
	.reset(reset),
	.data_1(demux_in1_out2) ,	// input [DATA_PACKET_SIZE-1:0] data_1_sig
	.data_2(demux_in2_out2) ,	// input [DATA_PACKET_SIZE-1:0] data_2_sig
	.select(select_mux3) ,	// input  select_sig
	.out(out3) 	// output [DATA_PACKET_SIZE-1:0] out_sig
);


   /***************************************************************/
  /*                        SCHEDULERS                           */
 /***************************************************************/

//MUX1 SCHEDULERS (one for each input)
muxScheduler SCHEDULER_CH1
(
	.clk(clk_rtr) ,	// input  clk_rtr_sig
	.reset(reset) ,	// input  reset_sig
	.port0_dataIN(!select_demux2) ,	// input  port0_dataIN_sig
	.port1_dataIN(!select_demux3) ,	// input  port1_dataIN_sig
	.select(select_mux1) 	// output  select_sig
);

//MUX2 SCHEDULERS (one for each input)
muxScheduler SCHEDULER_CH2
(
	.clk(clk_rtr) ,	// input  clk_rtr_sig
	.reset(reset) ,	// input  reset_sig
	.port0_dataIN(!select_demux1) ,	// input  port0_dataIN_sig
	.port1_dataIN(select_demux3) ,	// input  port1_dataIN_sig
	.select(select_mux2) 	// output  select_sig
);

//MUX3 SCHEDULERS (one for each input)
muxScheduler SCHEDULER_CH3
(
	.clk(clk_rtr) ,	// input  clk_rtr_sig
	.reset(reset) ,	// input  reset_sig
	.port0_dataIN(!select_demux1) ,	// input  port0_dataIN_sig
	.port1_dataIN(select_demux2) ,	// input  port1_dataIN_sig
	.select(select_mux3) 	// output  select_sig
);



 
//always@(posedge clk_rtr) //as long as the input FIFO aren't full we are ready to receive data
//begin
//  if(reset)
//   begin
//	  sink_ready1 <= 0;
//      sink_ready2 <= 0;
//      sink_ready3 <= 0;
//	end
//  else 
//   begin
//	  sink_ready1 <= !fifo1_mux_ch3_full && !fifo1_mux_ch2_full;
//      sink_ready2 <= !fifo2_mux_ch3_full && !fifo1_mux_ch1_full;
//      sink_ready3 <= !fifo2_mux_ch2_full && !fifo2_mux_ch1_full;
//   end
//end


always@(posedge clk_rtr) 
begin
   if(target_ready1)
	  select_mux1_out <= select_mux1;
	else
     select_mux1_out <= 'bz; 

   if(target_ready2)
	  select_mux2_out <= select_mux2;
	else
     select_mux2_out <= 'bz;
	 
	if(target_ready3)
	  select_mux3_out <= select_mux3;
	else
     select_mux3_out <= 'bz;	 
  
end

always@(posedge clk_rtr)
 begin:DEMUX_OUTPUT_SELECTION
  
  if(data_in1)//there's some data coming in from port 1 (west VR)
//  if(data_in1_out)//there's some data coming in from port 1 (west VR)
    begin
		if(in1[RANK_END:RANK_BEGIN] == RANK)      
			select_demux1 <= 0;
		else
		 if(in1[RANK_END:RANK_BEGIN] != RANK)
          select_demux1 <= 1;
		 else
          select_demux1 <= 'bz;		 
    end
  else
   select_demux1 <= 'bz;   
	 
	 if(data_in2)//there's some data coming in from port 2 (east VR)
//	 if(data_in2_out)//there's some data coming in from port 1 (west VR)
     begin
		if(in2[RANK_END:RANK_BEGIN] == RANK)      
			select_demux2 <= 0;
		else
		 if(in2[RANK_END:RANK_BEGIN] != RANK)
          select_demux2 <= 1;
		 else
          select_demux2 <= 'bz;		 
     end
	 else
	  select_demux2 <= 'bz; 
	 
//	 if(data_in3)//there's some data coming in from port 3 (north/south VR)  
	 if(data_in3_out)
		select_demux3 <= in3[VR_ID];	
	 else
        select_demux3 <= 'bz;		 
    
	 
 
 end




 FDRE #(
      .INIT(1'b0),          // Initial value of register, 1'b0, 1'b1
      // Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      .IS_C_INVERTED(1'b0), // Optional inversion for C
      .IS_D_INVERTED(1'b0), // Optional inversion for D
      .IS_R_INVERTED(1'b0)  // Optional inversion for R
   )
   Tagged_FF1 (
      .Q(data_in3_out),   // 1-bit output: Data
      .C(clk_rtr),   // 1-bit input: Clock
      .CE(1'b1), // 1-bit input: Clock enable
      .D(data_in3),   // 1-bit input: Data
      .R(reset)    // 1-bit input: Synchronous reset
   );
	 
	 
endmodule 
