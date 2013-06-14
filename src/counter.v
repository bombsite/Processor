//program counter 8 internal bits. 0-256
//can put 4 lower bits or 4 higher bits into/out of 1 bus


/*
Rst will reset the counter
PCH_W is a strobe, write when high
PCH_W_L writes to the left/high 4-bits, PCH_W_R writes to the right/lower 4-bits
PCH_I specifies which 4 bits to write to. 1 to upper 4 bits, 0 to lower 4 bits
PCH_R is a strobe, read when high
PCH_IN is the read value

PCH_LEFT, PCH_RIGHT are the two 4-bit registers in the PC

PCH_O is the output, always outputs the 4 lower bits when strobed
C_MEM value of the counter that is connected to memory

*/
module counter(Clk, Rst,PC_INC, PCH_INC, PCH_IN, PC_IN, PC_OUT, BUS_IN, BUS_OUT, C_MEM);

input Rst, Clk, PC_INC, PCH_INC, PCH_IN, PC_IN, PC_OUT;
input [3:0] BUS_IN;
output reg[3:0] BUS_OUT;
output wire [7:0] C_MEM;
reg [3:0] PC_LEFT, PC_RIGHT;

always@(negedge Clk) begin
	if(Rst == 1)begin
	  //reset both sides
		PC_LEFT <= 4'b0000;
		PC_RIGHT <= 4'b0000;
  end
	else begin
		
		//increment the counter
		if(PC_INC ==1) begin
		  
		  
		  if(PC_LEFT ==4'b1111 && PC_RIGHT == 4'b1111)begin
		    //do nothing
  		    PC_LEFT <= PC_LEFT;
		  end  
		  else if(PC_RIGHT == 4'b1111)begin
		    //carry over to left
		    PC_LEFT <= PC_LEFT+1;
		    PC_RIGHT <= 4'b0000;  
		  
		  end
		  else begin
		    //increment right
			 PC_RIGHT <= PC_RIGHT+1;
	   end
	  
	  end
	  if(PCH_INC ==1) begin
		  if(PC_LEFT == 4'b1111)begin
		    //carry over to left
		    PC_LEFT <= PC_LEFT;
		  end
		  else begin
		    //increment right
			 PC_LEFT <= PC_LEFT+1;
	   end
	  
	  end
	  
		//write
		if(PCH_IN == 1)begin
		  
		  PC_LEFT<=BUS_IN;
		end
		else if(PC_IN == 1)begin
		  PC_RIGHT<=BUS_IN;
		end
		
		//read

	end
	
end

		always@(PC_OUT)begin
		if(PC_OUT == 1)begin
			//read in lower bits into output
			BUS_OUT <= PC_RIGHT;
		end
		else begin
		  BUS_OUT <= 4'bzzzz;
		end
		end
		  
		  
//combine PCH_LEFT AND RIGHT for the 8-bit register to memory
assign C_MEM = {PC_LEFT, PC_RIGHT};


endmodule


