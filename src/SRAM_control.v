/*

R1_s is the register 1 strobe
Stack_s is the stack strobe 
RA_s is the register "a" strobe
CE is the Chip enable
RW read/write
Addr is address to SRAM

*/

// NOTE : IMPLEMENT OUTPUT ENABLE , R/W and CHIP ENABLE

module SRAM_control(Clk, Rst, R1_addr, SP_addr, R1_IN, R1_OUT, Stack_IN, Stack_OUT, RA_IN, RA_OUT, CE, OE, RW, Addr);
  
  input Clk, Rst, R1_IN, R1_OUT, Stack_IN, Stack_OUT, RA_IN, RA_OUT;
  input [1:0] R1_addr;
  input [2:0] SP_addr;
    
  output reg CE, RW, OE;
  output reg [3:0] Addr;

  always@(*)begin
    if(R1_IN==1)begin
      Addr <= {2'b00,R1_addr};
      if(Clk == 1) begin
      CE <= 1;
      OE <= 1;
      end
    end
    else if(R1_OUT==1)begin
      Addr <= {2'b00,R1_addr};
      CE <= 0;
      OE <= 0;
      RW <= 1;
    end
    else if(Stack_IN==1)begin
      Addr <= {1'b1,SP_addr};
      if(Clk == 1) begin
      CE <= 1;
      OE <= 1;
      end
    end
    else if(Stack_OUT==1)begin
      Addr <= {1'b1,SP_addr};
      CE <= 0;
      OE <= 0;
      RW <= 1;
    end
    else if(RA_IN == 1)begin
      Addr <= 4'b0000;
      if(Clk == 1) begin
      CE <= 1;
      OE <= 1;
      end
    end
    else if(RA_OUT == 1)begin
      Addr <= 4'b0000;
      CE <= 0;
      OE <= 0;
      RW <= 1;
    end
    else begin
      CE <= 1;
      OE <= 1;
    end
    
    
    if(Clk==0)begin
        if(R1_IN==1 || Stack_IN==1 | RA_IN == 1)begin
          CE <= 0;
          OE <= 1;
          RW <= 0;
        end
  end
  
    
  end
  
  
endmodule