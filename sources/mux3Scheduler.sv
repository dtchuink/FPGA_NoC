module mux3Scheduler(
	input clk,
	input reset,

	input port0_dataIN,
	input port1_dataIN,
	input port2_dataIN,

	output reg [1:0] select
);

//internal registers
reg [1:0] range_min = 2'b00, range_max = 2'b00, step = 2'b00;
reg [1:0] counter = 2'b00;
reg ready = 0;

//combinational component to determine based on the inputs, what the registers for step, range_min, 
//and range_max should hold (basically implementing a truth table for the 8 different combinations)
always@(*)
begin

    if(port0_dataIN == 0  && port1_dataIN == 0 && port2_dataIN == 1) //1
	begin		 
			step <= 0;
			range_min <= 2'b10;
			range_max <= 2'b10; 
    end 
	else if(port0_dataIN == 0  && port1_dataIN == 1 && port2_dataIN == 0) //2
	begin		 
			step <= 0;
			range_min <= 2'b1;
			range_max <= 2'b1; 
    end
	else if(port0_dataIN == 0  && port1_dataIN == 1 && port2_dataIN == 1) //3
	begin		 
			step <= 1;
			range_min <= 2'b1;
			range_max <= 2'b10; 
    end
	else if(port0_dataIN == 1  && port1_dataIN == 0 && port2_dataIN == 0) //4
	begin		 
			step <= 0;
			range_min <= 2'b0;
			range_max <= 2'b0; 
    end
	else if(port0_dataIN == 1  && port1_dataIN == 0 && port2_dataIN == 1) //5
	begin		 
			step <= 2'b10;
			range_min <= 2'b0;
			range_max <= 2'b10; 
    end
	else if(port0_dataIN == 1  && port1_dataIN == 1 && port2_dataIN == 0) //6
	begin		 
			step <= 2'b1;
			range_min <= 2'b0;
			range_max <= 2'b1; 
    end
	else if(port0_dataIN == 1  && port1_dataIN == 1 && port2_dataIN == 1) //7
	begin		 
			step <= 2'b1;
			range_min <= 2'b0;
			range_max <= 2'b10; 
    end
	else begin	//0 - no data to forward	 
			step <= 'bz;
			range_min <= 'bz;
			range_max <= 'bz; 
    end
end

//sequential component to calculate the next value for the counter register
always@(posedge clk)
begin
	if(reset) begin
		ready <= 0; //now must wait 1 cycle before knowing the right selection
		counter <= counter; //freeze counter where it is
	end
	else
	begin
		if(step === 'z)
			counter <= counter;
		else if((counter+step) > range_max)
			counter <= range_min;	
		else if((counter+step) < range_min)
			counter <= range_min;
		else
			counter <= counter+step;
		
		ready <= 1; //after reading inputs after one cycle counter is now accurate if its fresh off a reset
	end
end

//combinational block to avoid clock cycle delays between select output and counter register
always@(*) //"select" edition process
begin
	if(step === 'z || reset || ready == 0)
		select <= 'bz;
	else
    	select <= counter; 
end 

endmodule 
