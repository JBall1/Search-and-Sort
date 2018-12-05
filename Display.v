`timescale 1ns / 1ps

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

// use colorSelect to change between different filter values
reg [15:0] displayFreq = 0;
reg [1:0] colorSelectReg = 0;
    always @ (posedge CLK100MHZ) begin
         
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
    
//    always@(*) begin
//      if(freqBuffer > 80 && freqBuffer < 150) begin
//                  displayValue <= 16'b000000000000000;
//                  displayValue <= 16'b0000_0000_0110_0100;
////         end else if(freqBuffer >= 97 && freqBuffer < 100) begin
////                  displayValue <= 16'b0000_0000_0000_0000;
////                  displayValue <= 16'b0000_0000_1100_1000;
////         end else if(freqBuffer >= 100 && freqBuffer < 103) begin
////                  displayValue <= 16'b0000_0000_0000_0000;
////                  displayValue <= 16'b0000_0001_0010_1100;
                  
////         end else if(freqBuffer >= 103 && freqBuffer < 108) begin
////                  displayValue <= 16'b0000_0000_0000_0000;
////                  displayValue <= 16'b0000_0001_1001_0000;
                  
//     end else 
//        displayValue <= 16'b0000_0000_0000_0000;
//    end
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
