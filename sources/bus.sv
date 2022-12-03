`ifndef BUS_SV
`define BUS_SV


interface bus #(parameter DATA_PACKET_SIZE = 32);//192
logic ready; //data_in
logic valid;//data_out
logic [(DATA_PACKET_SIZE-1):0] data;

 modport source (input ready, output data,valid);//the source sends data out
 modport sink (output ready, input data, valid);// the sink just receives data
 
 //communication direction  source -> sink 
  

endinterface 

`endif 
