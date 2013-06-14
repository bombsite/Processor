module EEPROM (address, data);
/*
parameter JC 	= 4'b1111;
parameter JMP 	= 4'b1110;
parameter MOV 	= 4'b1101;
parameter MVI 	= 4'b1100;
parameter INC 	= 4'b1011;
parameter ADD 	= 4'b1010;
parameter SUB 	= 4'b1001;
parameter I_AND = 4'b1000;
parameter I_OR 	= 4'b0111;
parameter SC 	= 4'b0110;
parameter CC 	= 4'b0101;
parameter PUSH 	= 4'b0100;
parameter POP 	= 4'b0011;
parameter IN 	= 4'b0010;
parameter OUT 	= 4'b0001;
parameter NOP 	= 4'b0000;
*/

  parameter JC =    4'b0000;  //0
  parameter JMP =   4'b0001;  //1
  parameter MOV =   4'b0010;  //2 
  parameter MVI =   4'b0011;  //3
  parameter INC =   4'b0100;  //4
  parameter ADD =   4'b0101;  //5
  parameter SUB =   4'b0110;  //6
  parameter AND =   4'b0111;  //7
  parameter OR  =   4'b1000;  //8
  parameter SC  =   4'b1001;  //9
  parameter CC  =   4'b1010; //10
  parameter PUSH =  4'b1011; //11
  parameter POP =   4'b1100; //12
  parameter IN  =   4'b1101; //13
  parameter OUT =   4'b1110; //14
  parameter NOP =   4'b1111; //15

input [7:0] address;
output [7:0] data;


reg [7:0] data;

always @(address) begin
	case(address)
		/*
		// write your test program here
		8'h00 : data = {MVI, 4'b1010}; // reg0 = 1010
		8'h01 : data = {MOV, 4'b0100}; // reg1 = 1010
    */
    
    //DEFINE: RA, RB, RC, RD
    //DEFINE: 00, 01, 10, 11
    
    /*  Start */
    8'h00 : data = {IN , 4'b1000}; //put input from DIP switches into RC
    8'h01 : data = {OR , 4'b1010}; //OR together RC and RC
    //init registers
    8'h02 : data = {CC, 4'b0000}; //clear carry
    8'h03 : data = {MVI, 4'b0000}; //move value of 0 into RA
    8'h04 : data = {MOV, 4'b1100}; //move value of RA(0) into RD
    8'h05 : data = {AND, 4'b0100}; //move value of RA(0) into RB
    8'h06 : data = {MOV, 4'b0010}; //move value of RC into RA
    //count=input*4
    8'h07 : data = {ADD, 4'b1000}; //RC=RC+RA (count*2)
    8'h08 : data = {ADD, 4'b1101}; //RD=RD+0+carry
    8'h09 : data = {ADD, 4'b1000}; //RC=RC+RA (count*3)
    8'h0a : data = {ADD, 4'b1101}; //RD=RD+0+carry
    8'h0b : data = {ADD, 4'b1000}; //RC=RC+RA (count*4)
    8'h0c : data = {ADD, 4'b1101}; //RD=RD+0+carry
    //init output same as input value
    8'h0d : data = {OUT, 4'b0000}; //output to LEDs
    //save to stack
    8'h0e : data = {PUSH, 4'b1000}; //push RC, count.ls
    8'h0f : data = {PUSH, 4'b1100}; //push RD, count.ms
    8'h10 : data = {PUSH, 4'b0000}; //push RA, last output
    8'h11 : data = {PUSH, 4'b0000}; //push RA, init output
    //main prog loop
    //main delay loop, inc count until overflow (carry) occurs
    
    /*  main  */
    8'h12 : data = {MVI, 4'b0011}; //loop1.ls address stored in RA, store 3 into RA
      
    /*  loop1  */
    8'h13 : data = {INC, 4'b1000};  //RC = RC+1
    8'h14 : data = {ADD, 4'b1101};  //RD = 0+carry
    8'h15 : data = {NOP,4'b0000}; //increase delay with nop
    8'h16 : data = {JC, 4'b0010}; // branch 2 instructions forward
    8'h17 : data = {JMP, 4'b0001}; // branch to 1X, where X is stored in RA
    //check if user changed the input value
    
    /*  break1  */
    8'h18 : data = {POP, 4'b1100};  //pop RD. Restore initial input value
    8'h19 : data = {MOV, 4'b1011};  //mov RD,RC. save value into RC
    8'h1a : data = {IN, 4'b0000};   //in RA. read current input value
    8'h1b : data = {SC, 4'b0000};   //prepare for equity check
    8'h1c : data = {SUB, 4'b1100};  //RD will be 0 if RA==RD
    8'h1d : data = {MVI, 4'b0001}; //MVI RA,1. prepare to do zero check
    8'h1e : data = {SC, 4'b0000};
    8'h1f : data = {SUB, 4'b1100};  //carry(overflow) produced if not zero
    8'h20 : data = {JC, 4'b1111}; //jump to break2. need to recompute count
    //compute logical inverse of last output and make it the new output
    8'h21 : data = {POP, 4'b0000}; //pop RA. restore last output value
    8'h22 : data = {SUB, 4'b0100}; //sub RB,RA. RB=0-RA or RB=~RA
    8'h23 : data = {OUT, 4'b0100};  //output the value
    8'h24 : data = {MOV, 4'b0010};  //mov RC,RA. saved initial input to RA
    8'h25 : data = {POP, 4'b1100}; //pop RD. restore computed value
    8'h26 : data = {POP, 4'b1000};  //pop RC.
    //restore the stack for next iteration
    8'h27 : data = {PUSH, 4'b1000}; //push RC. ls count nibble
    8'h28 : data = {PUSH, 4'b1100}; //push RD. ms count nibble
    8'h29 : data = {PUSH, 4'b0100}; //push RB. last output value
    8'h2a : data = {PUSH, 4'b0000}; //push RA. init input value
    //set RB to zero
    8'h2b : data = {MVI, 4'b0000}; //MVI RA,0. 
    8'h2c : data = {MOV, 4'b0100}; //mov RA,RB
    8'h2d : data = {MVI, 4'b0010}; //mvi RA,main.ls. store LSB of 2 into RA.
    8'h2e : data = {JMP, 4'b0001}; //jump to 1X, where X is stored in RA.
    //restart if user has changed the input value
    
    /*  break2  */
    8'h2f : data = {POP, 4'b0000}; //pop RA. flush the stack
    8'h30 : data = {POP, 4'b0000}; //pop RA.
    8'h31 : data = {POP, 4'b0000}; //pop RA.
    8'h32 : data = {POP, 4'b0000}; // ADDED POP TO CLEAR THE STACK
    8'h33 : data = {MVI, 4'b0000}; //mvi RA,start.ls. store LSB of start into RA.
    8'h34 : data = {JMP, 4'b0000}; //jump to 0X. Where X is 0.
    
    
    
    
    
		default : data = 8'hFF;
		          //test = 8'hFF;
	endcase
end
endmodule
