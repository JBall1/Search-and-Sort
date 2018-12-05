`timescale 1ns / 1ps
//A simple display module used to display a 16 bit value to the Basys 3 Display.
module Display(
input CLK100MHZ,
input [15:0] outputVal,
output [7:0] sseg,
output [3:0] enables
    );    
reg [15:0] displayValue = 0;
reg [15:0] freqBuffer = 0;
reg [1:0] pastFilter = 0; 
reg [5:0] delayMag = 0;
reg [1:0] currentFilter = 0;

reg [15:0] displayFreq = 0;
reg [1:0] colorSelectReg = 0;
    always @ (posedge CLK100MHZ) begin
         //Delay 
 if (pastFilter == currentFilter && currentFilter == colorSelectReg) begin
           freqBuffer <= outputVal;
           delayMag <= delayMag + 1;
       end
       else begin
           freqBuffer <= freqBuffer;
       end
       
       if (delayMag > 28) begin
           displayFreq <= outputVal;
           delayMag <= 0;
       end
       pastFilter <= currentFilter;
       
       
       
     
   end
    
    sevensegment segs(
    .CLK100MHZ(CLK100MHZ),
    .reset(0),
    .inBits(freqBuffer),
    .a(sseg[0]),
    .b(sseg[1]),
    .c(sseg[2]),
    .d(sseg[3]),
    .e(sseg[4]),
    .f(sseg[5]),
    .g(sseg[6]),
    .dp(sseg[7]),
    .an(enables)
    );

    
endmodule
