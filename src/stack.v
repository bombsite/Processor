module stack(Clk, Rst, SP, SP_INC, SP_DEC, FULL, EMPTY);

  input Clk, Rst, SP_INC, SP_DEC;
  output reg FULL = 0, EMPTY = 1;
  output reg [2:0] SP;

  always@(negedge Clk)begin
    if(Rst==1)begin
      SP <= 3'b000;
      EMPTY <= 1;
    end
    else begin
      //controller to increment or dec the controller
      if(SP_INC==1)begin
        if(SP == 3'b111)
          FULL<=1;
        else if(EMPTY==1)
          EMPTY<=0;
        else
          SP<=SP+1;
      end
      else if(SP_DEC==1)begin
        if(EMPTY==1)
          EMPTY<=1;
        else if(SP == 3'b000)begin
          EMPTY <= 1;
        end
        else begin
          FULL<=0;
          SP<=SP-1;
        end
      end
        
          
    end
  
  end
  
  
endmodule