//==============================================================================
// Testbench module for EEPROM/testing purposes
//==============================================================================
 
`timescale 1ns / 1ps
 
 
module ECE152_tb;
 
reg Clock, Reset;
 
 
//reg [7:0] address;
//wire [7:0] data;
 

reg [3:0] DAT_IN;
wire [3:0] DAT_OUT;
 
 
lab2 DUT (
        .Clk(Clock),
        .Rst(Reset),
        .DAT_IN(DAT_IN),
        .DAT_OUT(DAT_OUT)
        //.A(A), .B(B), .C(C), .D(D),
        //.X(X), .Y(Y), .Z(Z)
        //.address(address),
        //.data(data)
);
 
initial begin
Clock = 0;
Reset = 1;
DAT_IN = 4'b0000;
//A = 1;        // begin by testing loopback in top center
//B = 1;        // take left path first time through
//C = 0;        // pass through
//D = 1;        // pass through first time when doing the right-side path
 
//address = 8'h05;
 
 
#10 Reset = 0;  // take out of reset
 
 
#100000 DAT_IN = 4'b1111;
//#15 address = 8'h05;
 
//#20 A = 0;    // finish testing top-center loopback
 
//wait (DUT.State == 3'b000) C = 1;     // test skip-over path
 
//#20 wait (DUT.State == 3'b000) B = 0; // test right-side path
 
//#20 wait (DUT.State == 3'b000) D = 0; // test loopback path on right side
 
 
end
 
always #5 Clock = ~Clock;
 
// Display simulator time, and register and signal values on falling edge of clock
 
/*
initial $display("t > S : ABCD : XYZ");
always @ (negedge Clock)
        $display("%3d > %3b : %b%b%b%b : %b%b%b", $stime, DUT.State, A,B,C,D, X,Y,Z);
*/
 
//==============================================================================
// End of testbench module
//==============================================================================
endmodule