module accumulator(Clk, Rst, ACC_IN, ACC_OUT, ACC_VAL_IN, ACC_VAL_OUT);
  input Clk, Rst, ACC_IN, ACC_OUT;
  input [3:0] ACC_VAL_IN;
  output reg [3:0]ACC_VAL_OUT;
  reg[3:0] ACC_VALUE;
  
  always@(negedge Clk)
  begin
    if(Rst==1)
      ACC_VALUE <=0;
    
    if(ACC_IN ==1)
      ACC_VALUE <= ACC_VAL_IN;
      
  end
  
  always@(ACC_OUT)
  begin    
    if(ACC_OUT==1)
      ACC_VAL_OUT <= ACC_VALUE;
    else 
      ACC_VAL_OUT<=4'bzzzz;
  end
  
endmodule