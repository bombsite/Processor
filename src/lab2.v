//lab2.v
//module for connecting everything together
 
 /*
SRAM s2(
.ce_r(~R2_OUT), // should be opposite of R2_out
.oe_r(~R2_OUT), // should be opposite of R2_out
.rw_r(1), //set this to 1 ( is this code ok? ), // read only on the right side
.address_r(INT_T), //get the r2 address and pad it
.data_out_r(BUS_B), //strobe to output right data, connect to control
.ce_l(CE_L), //connect to SRAM control
.oe_l(OE_L), //connect to SRAM control
.rw_l(RW_L), //connect to SRAM control
.address_l(addr_L), //connect to SRAM control
.data_out_l(BUS_A) //strobe to output left data, connect to control
);

EEPROM e1(
.address(C_MEM), //output from PC to eeprom
.data(EEPROM_IN) //data output to IR
);

Circuit74181 c3(
.S(ALU_S), // control bits for ALU
.A(BUS_A), // input A for ALU, from BUS A
.B(BUS_B), //input B for ALU, from BUS B
.M(ALU_M), // control bits for ALU
.CNb(Cin), // input carry-in for ALU
.F(ACC_VAL_IN), // connect to accumulator
.X(X),
.Y(Y),
.CN4b(Cout), // carry-out output from ALU
.AEB(AEB)
);
 

 */


module lab2 (
Clk,
Rst,
DAT_IN,
DAT_OUT,
//SRAM wires
ce_oe_r_out, //opposite of R2_OUT
SRAM_Add_r, //SRAM Address to right side
BUS_B,
BUS_A,
CE_L,
OE_L,
RW_L,
addr_L,
//ALU wires
ALU_S,
ALU_M,
Cin,
ACC_VAL_IN,
Cout,

//eeprom wires
C_MEM,
EEPROM_IN


);
input Clk, Rst;
 
//sram
output ce_oe_r_out;
output [1:0] SRAM_Add_r;
inout [3:0]BUS_B;
inout [3:0]BUS_A;
output CE_L,OE_L,RW_L;
output [3:0]addr_L;

//alu

output [3:0] ALU_S;
output ALU_M, Cin;
input Cout;
input [3:0] ACC_VAL_IN;


//eeprom
output [7:0] C_MEM;
input [7:0] EEPROM_IN;


wire load_IR; // strobe IR to load from eeprom from control
wire data_out; // strobe IR to put lsb onto bus from control
 
wire PCH_INC, PC_INC, PC_OUT; //increment program counter high
wire PCH_W_L, PCH_W_R; // strobe for writing to higher and lower bits of PC
//wire [7:0] C_MEM; //wire from output of PC to EEPROM
 
wire SP_INC, SP_DEC; //increment and decrement stack pointer
wire FULL, EMPTY; //status of the stack
 
wire [2:0] SP_addr; // 3 bit stack pointer address
wire R1_IN; //strobe for R1_in
wire R1_OUT; //strobe for R1_out
wire Stack_IN, Stack_OUT; //strobe for stack in and out
wire RA_IN, RA_OUT; //strobe for RA in and RA out
 
//wire CE_L, OE_L, RW_L; //left settings for the sram
//wire [3:0] addr_L; //left address for sram
//wire data_out_l; //strobe signal for sram data left
 
 
//wire [7:0] EEPROM_IN; // connect eeprom to IR
wire [7:0] TO_CONTROL; //connect IR output
 
//wire [3:0] ALU_S; //control wires for ALU
//wire ALU_M;
//wire [3:0] ACC_VAL_IN; // input value from accumulator
//wire X, Y; //hanging wires. unused
 
wire ACC_IN, ACC_OUT; //strobes for accumulator
 
//wire [3:0] BUS_A;
//wire [3:0] BUS_B;
 
//wire [7:0] BUS_A_SRAM;
//wire [7:0] BUS_B_SRAM;
 
wire R2_OUT;
 
//wire [3:0] INT_T; //intermediate temp value for an operation
 
//wire Cin, Cout;
//wire Cout;

wire IN_I;
wire OUT_I; // in and out strobe wires
 
input [3:0] DAT_IN;
output [3:0] DAT_OUT;
 


assign ce_oe_r_out = ~R2_OUT;
assign SRAM_Add_r = TO_CONTROL[1:0];
//assign INT_T = {(2'b00),TO_CONTROL[1:0]};
 
CONTROL c1(
.Clk(Clk),
.Rst(Rst),
 
.IN_I(IN_I), // dip switch in
.OUT_I(OUT_I), // led out
 
.load_IR(load_IR), // load_IR strobe
.IR_IN(TO_CONTROL), // IR output to control
.data_out(data_out), //strobe data from IR to bus
.PCH_INC(PCH_INC), //strobe to increment the PC
.PCH_IN(PCH_W_L), //strobe to write to higher bits of PC
.PC_IN(PCH_W_R), //strobe to write to lower bits of PC
.PC_INC(PC_INC),
.PC_out(PC_OUT), //strobe to read lower bits of PC to bus B
.SP_INC(SP_INC), //inc the stack pointer
.SP_DEC(SP_DEC), //dec the stack pointer
.overflow(FULL), // stack is full
.empty(EMPTY), //stack is empty
 
.ALU_S(ALU_S),
.ALU_M(ALU_M),
.Cout(Cout),
.Cin(Cin),
 
 
.ACC_IN(ACC_IN), //strobe to read into accumulator
.ACC_OUT(ACC_OUT), //strobe to write from accumulator to bus
 
.R1_IN(R1_IN), //strobe for R1_IN connected to sram_control
.R1_OUT(R1_OUT), //strobe for R1_OUT connected to sram_control
.STACK_IN(Stack_IN), //strobe for stack in, connected to sram control
.STACK_OUT(Stack_OUT), //strobe for stack out, connected to sram control
.RA_IN(RA_IN), //strobe for RA_IN connected to sram control
.Read_RA(RA_OUT), //strobe for RA_OUT connected to sram control
 
 
//.R1_OUT(data_out_l), //strobe for data out for left side of sram
.R2_OUT(R2_OUT) //strobe for data out for right side of sram
);
 

 
InstrRegister r1(
.Rst(Rst),
.load(load_IR), //strobe the data from eeprom into IR
.EEPROM_IN(EEPROM_IN), //data input from eeprom
.TO_CONTROL(TO_CONTROL), //IR output to control
.data_out(data_out), //strobe the data from IR to bus
.REG_OUT_BUS(BUS_A) //connect output of IR to bus
);
 
counter c2(
.Clk(Clk),
.Rst(Rst),
.PC_INC(PC_INC),
.PCH_INC(PCH_INC), //strobe to increment the PC.  
.PCH_IN(PCH_W_L),
.PC_IN(PCH_W_R),
.PC_OUT(PC_OUT),
.BUS_IN(BUS_A),
.BUS_OUT(BUS_B),
.C_MEM(C_MEM)
);
 
stack s1(
.Clk(Clk),
.Rst(Rst),
.SP(SP_addr), // stack pointer address connect to SRAM control
.SP_INC(SP_INC), //increment the stack pointer
.SP_DEC(SP_DEC), //dec the stack pointer
.FULL(FULL), //stack is full
.EMPTY(EMPTY) //stack is empty
);
 

SRAM_control s3(
.Clk(Clk),
.Rst(Rst),
.R1_addr(TO_CONTROL[3:2]), //get the R1 bits from IR
.SP_addr(SP_addr), //stack pointer address
.R1_IN(R1_IN), //strobe for R1_in connected to control
.R1_OUT(R1_OUT), //strobe for R1_out connected to control
.Stack_IN(Stack_IN), //strobe for stack in connected to control
.Stack_OUT(Stack_OUT), //strobe for stack out connected to control
.RA_IN(RA_IN), //strobe for RA_IN
.RA_OUT(RA_OUT), //strobe for RA_OUT
.CE(CE_L), //chipenable left connected to sram
.OE(OE_L), //outputenable left connect to sram
.RW(RW_L), //readwrite left connect to sram
.Addr(addr_L) //address left connect to sram
);
 
Circuit74181 c3(
.S(ALU_S), // control bits for ALU
.A(BUS_A), // input A for ALU, from BUS A
.B(BUS_B), //input B for ALU, from BUS B
.M(ALU_M), // control bits for ALU
.CNb(Cin), // input carry-in for ALU
.F(ACC_VAL_IN), // connect to accumulator
.X(X),
.Y(Y),
.CN4b(Cout), // carry-out output from ALU
.AEB(AEB)
);
 

accumulator a2(
.Clk(Clk),
.Rst(Rst),
.ACC_IN(ACC_IN), //strobe for accumulator in
.ACC_OUT(ACC_OUT), //strobe for accumulator out
.ACC_VAL_IN(ACC_VAL_IN), // input from ALU
.ACC_VAL_OUT(BUS_A) // output from ALU straight to BUS A
);
 
BUFFER b3(
.control_input(IN_I),
.data_input(DAT_IN),
.data_output(BUS_A)
); // buffer for IN
 
 
REG_374 b4(
.clk(~Clk&OUT_I), 
.input_data(BUS_A), 
.output_data(DAT_OUT)
); // buffer for OUT
endmodule