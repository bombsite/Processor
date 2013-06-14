/*

load is strobe for eeprom into register
data_out is strobe for register into bus

*/

module InstrRegister( Rst, EEPROM_IN, REG_OUT_BUS, TO_CONTROL, load, data_out);
  
  input Rst, load, data_out;
  input [7:0] EEPROM_IN;
  output reg [3:0] REG_OUT_BUS;
  output reg [7:0] TO_CONTROL;
  
always@(*)begin
  if(load==1)
      TO_CONTROL <= EEPROM_IN;
  
  if(data_out==1)
    REG_OUT_BUS <= TO_CONTROL[3:0];
  else
    REG_OUT_BUS <= 4'bzzzz;


  
  
end  
  
  
endmodule