module FPGA_sharing_Noc
#(
   parameter NUM_ROUTER = 20,
	parameter DATA_PACKET_SIZE = 32, //192
   parameter RANK_BEGIN = 5,
   parameter RANK_END = 8,
   parameter VR_ID = 9,
   parameter FIFO_DEPTH = 4
)
(
  input clk_rtr,
  //input clk_vr,
  
  input reset,
  
  bus.source PCI_src,
  bus.sink PCI_sink
  
//  bus.source default_src_west,
//  bus.sink default_sink_west
  
  
);

//ground buses
bus ground_bus_src[(NUM_ROUTER-1):0]();
bus ground_bus_sink[(NUM_ROUTER-1):0]();

//inter-router links
bus link_south_north[(NUM_ROUTER-1):0]();
bus link_north_south[(NUM_ROUTER-1):0]();


genvar j;//Generation of the connections to the ground (we'll ground East and West interfaces to routers since we dont have PEs)
  generate
    for (j=0; j < NUM_ROUTER; j=j+1)
      begin: groundGen
         //ground_bus[j]();
         assign ground_bus_sink[j].valid = 0;
         assign ground_bus_sink[j].data = 0; 
         
         assign ground_bus_src[j].ready = 0; 
      end
  endgenerate 
                   
genvar i; // Generation of the list of connected routers without PE support, and no Pblock
  generate
    for (i=0; i < NUM_ROUTER; i=i+1)
     begin: routerGen
       //generate
          if (i==0) begin: bottomRouter //3-port router
            router3Input
                        #(
                        .RANK(i),
                        .DATA_PACKET_SIZE(DATA_PACKET_SIZE),
                        .RANK_BEGIN(RANK_BEGIN),
                        .RANK_END(RANK_END),
                        .VR_ID(VR_ID),
                        .FIFO_DEPTH(FIFO_DEPTH)
                        )
                        R3
                               (
                                 .clk_rtr(clk_rtr),
                                 .reset(reset),   
                                 .north_src(link_south_north[i].source), 
                                 .north_sink(link_north_south[i].sink), 
                                  
                                 .east_src(PCI_src),//IO port that connects maybe to the PCI interface
                                 .east_sink(PCI_sink),//IO port that connects maybe to the PCI interface
                                 
                                 .west_src(ground_bus_src[i].source), 
                                 .west_sink(ground_bus_sink[i].sink)
                );
          end else if (i==(NUM_ROUTER-1)) begin: topRouter //3-port router
            router3Input
                        #(
                        .RANK(i),
                        .DATA_PACKET_SIZE(DATA_PACKET_SIZE),
                        .RANK_BEGIN(RANK_BEGIN),
                        .RANK_END(RANK_END),
                        .VR_ID(VR_ID),
                        .FIFO_DEPTH(FIFO_DEPTH)
                        )
                        R3
                               (
                                 .clk_rtr(clk_rtr),
                                 .reset(reset),   
                                 .north_src(link_north_south[i-1].source), 
                                 .north_sink(link_south_north[i-1].sink), 
                                  
                                 .east_src(ground_bus_src[i].source),
                                 .east_sink(ground_bus_sink[i].sink),
                                 .west_src(ground_bus_src[i].source), 
                                 .west_sink(ground_bus_sink[i].sink)
                );
          end else begin: intermediateRouter //4-port router
            router4Input
                       #(
                         .RANK(i),
                         .DATA_PACKET_SIZE(DATA_PACKET_SIZE),
                         .RANK_BEGIN(RANK_BEGIN),
                         .RANK_END(RANK_END),
                         .VR_ID(VR_ID),
                         .FIFO_DEPTH(FIFO_DEPTH)
                       )
                        R4
                                  (
                                     .clk_rtr(clk_rtr),
                                     .reset(reset),
                                     .north_src(link_south_north[i].source), 
                                     .north_sink(link_north_south[i].sink), 
                                     
                                     .south_src(link_north_south[i-1].source), 
                                     .south_sink(link_south_north[i-1].sink),
                                     
                                     .east_src(ground_bus_src[i].source),
                                     .east_sink(ground_bus_sink[i].sink),
                                     .west_src(ground_bus_src[i].source), 
                                     .west_sink(ground_bus_sink[i].sink)     
                                  );
          end
       //endgenerate
     end
  endgenerate 



   


	

endmodule 
