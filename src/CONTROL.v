module CONTROL 
(
Clk,
Rst,
IR_IN,

ALU_S,		//Used for ALU Control
ALU_M,		//Used for ALU Control

load_IR,  //strobe to load into IR
data_out, //strobe for data to be outputted from SRAM
PC_out,   //strobe for output of Program Counter
//ADD_I,      //strobe telling ALU to add


ACC_OUT,  //strobe to move data to
PC_IN,    //strobe for Program counter in, lower bits
PCH_INC,  //strobe telling program counter to increment
Cout,     //value of Cout from ALU
Cin,		  //To Cin of ALU

PCH_IN,   //strobe for writing into higher bits of PC
Read_RA,     //strobe for reading sram to bus


ACC_IN,   //strobe for accumulator input
R1_IN,    //strobe for R1 in
RA_IN,    //strobe for reading into RA
//B_TO_ACC, //strobe for moving B to accumulator

R1_OUT,   //strobe for R1 out
//INC_I,      //strobe for doing INC in ALU

R2_OUT,   //strobe for R2 out
//AND_I,    //strobe for doing AND in ALU
//AND_I,    //strobe for doing AND in ALU

//SUB_I,      //strobe for doing SUB in ALU


//A_TO_ACC, //strobe to move A to accum

SP_INC,   //strobe for increment stackpointer
SP_DEC,   //strobe for decrement stackpointer
STACK_IN, //strobe for stack input

STACK_OUT,//strobe for stack output

IN_I,       //strobe for IN
OUT_I,      //strobe for OUT

PC_INC,  //strobe for increment the PC

overflow,
empty    //inputs for stack's status

);
  
  // parameters for the OPCODES
  parameter JC = 0;
  parameter JMP = 1;
  parameter MOV = 2;
  parameter MVI = 3;
  parameter INC = 4;
  parameter ADD = 5;
  parameter SUB = 6;
  parameter AND = 7;
  parameter OR  = 8;
  parameter SC  = 9;
  parameter CC  = 10;
  parameter PUSH = 11;
  parameter POP = 12;
  parameter IN  = 13;
  parameter OUT = 14;
  parameter NOP = 15;


  //regs
  reg CY = 1;
    
  // inputs & outputs
  
  input Clk, Rst;
  input [7:0] IR_IN;
  reg [2:0] step_counter = 0;
  input Cout;
  input overflow,empty;
  
  output reg [3:0] ALU_S;
  
  output reg load_IR,data_out,PC_out,ACC_OUT,PC_IN,PCH_INC,PCH_IN,Read_RA,ACC_IN,
          R1_IN,RA_IN,R1_OUT,R2_OUT,SP_INC,SP_DEC,
          STACK_IN,STACK_OUT,IN_I,OUT_I,PC_INC,Cin,ALU_M;
  
  
  always@(posedge Clk)begin
    
    // zero everything
    load_IR=0;
    data_out=0;
    PC_out=0;
    //ADD_I=0;
    ACC_OUT=0;
    PC_IN=0;
    PCH_INC=0;
    PCH_IN=0;
    Read_RA=0;
    ACC_IN=0;
    R1_IN=0;
    RA_IN=0;
    //B_TO_ACC=0;
    R1_OUT=0;
    //INC_I=0;
    R2_OUT=0;
    //SUB_I=0;
    //A_TO_ACC=0;
    SP_INC=0;
    SP_DEC=0;   
    STACK_IN=0;
    STACK_OUT=0;
    IN_I=0;
    OUT_I=0;
    PC_INC=0;
    //AND_I=0;
    Cin = 0;
    
    if(Rst==1)begin
      step_counter =0;
    end
    else begin
      
    case(IR_IN[7:4])
      JC: begin //Carry might want to be set to HIGH to prevent an addition of 1
        case(step_counter)
          0:load_IR = 1;
          1:begin
            if(CY == 0) begin
              data_out =1;
              PC_out = 1;
              //ADD_I <=1;
              //ADD ALU
              ALU_S = 4'b1001;
              ALU_M = 0;
              ACC_IN =1;
              Cin=1;
            end
          end
          2:begin
            if(CY == 0) begin
              ACC_OUT=1;
              PC_IN=1;
              PCH_INC=~Cout;
            end
            else PC_INC=1;
          end
        endcase
      end    
      JMP:begin
        case(step_counter)
          0:load_IR =1;
          1:begin
            data_out=1;
            PCH_IN=1;
          end
          2:begin
            Read_RA=1;
            PC_IN=1;
          end
        endcase
      end
      MOV:begin
        case(step_counter)
          0:load_IR=1;
          1:begin
            PC_INC=1;
            ACC_IN=1;
            R2_OUT=1;
            //B_TO_ACC<=1; 
            //B = F in ALU
            ALU_S = 4'b1010;
            R1_OUT= 1; //DEBUG, see if ALU needs two inputs for F = B
            ALU_M = 1;
          end
          2:begin
            R1_IN=1;
            ACC_OUT=1;
          end
        endcase
      end
      MVI:begin
        case(step_counter)
          0:load_IR=1;
          1:begin
            PC_INC=1;
            RA_IN=1;
            data_out=1;
          end
        endcase
      end
      INC:begin //Note: Carry must be set to LOW before this instruction to work
        case(step_counter)
          0:load_IR=1;
          1:begin
            PC_INC=1;
            R1_OUT=1;
            ACC_IN=1;
            //INC_I<=1;
            //ALU INC
            ALU_S = 4'b0000; //DEBUG WAS b0000
            ALU_M = 0;
            //R2_OUT = 1; //FOR ALU //DEBUG
            Cin = 0;
          end
          2:begin
            R1_IN=1;
            ACC_OUT=1;
          end
        endcase
      end
      ADD:begin
        case(step_counter)
          0:load_IR=1;
          1:begin
            R1_OUT=1;
            R2_OUT=1;
            ACC_IN=1;
            //ADD_I<=1;
            //ALU ADD
            ALU_S = 4'b1001;
            ALU_M = 0;
            Cin = CY;
            PC_INC=1;
          end
          2:begin
            ACC_OUT=1;
            R1_IN=1;
          end
        endcase
      end
      SUB:begin
        case(step_counter)
          0:load_IR=1;
          1:begin
            R1_OUT=1;
            R2_OUT=1;
            ACC_IN=1;
            //SUB_I<=1;
            //ALU SUB
            ALU_S = 4'b0110;
            ALU_M = 0;
            Cin = CY;
            PC_INC=1;
          end
          2:begin
            ACC_OUT=1;
            R1_IN=1;
          end
        endcase  
      end
      AND:begin
        case(step_counter)
          0:load_IR=1;
          1:begin
            R1_OUT=1;
            R2_OUT=1;
            ACC_IN=1;
            //AND_I<=1;
            //ALU AND
            ALU_S = 4'b1011;
            ALU_M = 1;
            PC_INC=1;
          end
          2:begin
            ACC_OUT=1;
            R1_IN=1;
          end
        endcase
      end
      OR:begin
        case(step_counter)
          0:load_IR=1;
          1:begin
            R1_OUT=1;
            R2_OUT=1;
            ACC_IN=1;
            //OR_I<=1;
            //ALU OR
            ALU_S = 4'b1110;
            ALU_M = 1;
            PC_INC=1;
          end
          2:begin
            ACC_OUT=1;
            R1_IN=1;
          end
        endcase
      end
      SC:begin
        case(step_counter)
          0:load_IR=1;
          1:begin
            //CY<=0;
            PC_INC=1;
          end
        endcase
      end
      CC:begin
        case(step_counter)
          0:load_IR=1;
          1:begin
            //CY<=1;
            PC_INC=1;
          end
        endcase
      end
      PUSH:begin
        case(step_counter)
          0:load_IR=1;
          1:begin
            R1_OUT=1;
            ACC_IN=1;
            //A_TO_ACC<=1; 
            //ALU A = F
            ALU_S = 4'b1111;
            ALU_M = 1;
            R2_OUT = 1; //FOR ALU
            PC_INC=1;
            SP_INC=1;
          end
          2:
          if(overflow==0)begin
            ACC_OUT=1;
            STACK_IN=1;
          end
        endcase
      end
      POP:begin
        case(step_counter)
          0:load_IR=1;
          1:begin
            STACK_OUT=1;
            ACC_IN=1;
            //A_TO_ACC<=1;
            //ALU A = F
            ALU_S = 4'b1111;
            ALU_M = 1;
            R2_OUT = 1; //FOR ALU
            PC_INC=1;
          end
          2:begin
            SP_DEC=1;
            if(empty==0)begin
              ACC_OUT=1;
              R1_IN=1;
            end
          end
          
        endcase
      
      end
      IN:begin
        case(step_counter) 
          0:load_IR=1;
          1:begin
            IN_I=1;
            R1_IN=1;
            PC_INC=1;
          end
        endcase
      end
      OUT:begin
        case(step_counter)
          0:load_IR=1;
          1:begin
            OUT_I=1;
            R1_OUT=1;
            PC_INC=1;
          end
        endcase
      end
      NOP:begin
        case(step_counter)
          0:load_IR=1;
          1:PC_INC=1;
        endcase
      end
      default:load_IR=1;
      
  endcase
  
  
  step_counter=step_counter+1;
  if(step_counter >2)
    step_counter=0;
     
     
  end   
  end //end the always@
  
  //STUB : 
  //update carry on neg-edge 
  
  always@(negedge Clk)begin
	case(IR_IN[7:4])
	INC:begin
		case(step_counter)
		2:CY=Cout;
		endcase
	end
	ADD:begin
		case(step_counter)
		2:CY=Cout;
		endcase
	end
	SUB:begin
		case(step_counter)
		2:CY=Cout;
		endcase
	end
	SC:begin
        case(step_counter)
          2:CY=0;
        endcase
      end
  CC:begin
        case(step_counter)
          2:CY=1;
        endcase
      end
	endcase
  
  end
  
endmodule
