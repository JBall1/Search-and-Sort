`timescale 1ns / 1ps



module freqControl(
input CLK100MHZ,                                        
input signal,                                         
output reg [5:0] counter = 0,                                 
output reg [15:0] freq = 0//, // ratio of [color] filter frequency versus clear clear filter frequency
//output reg [1:0] Color
    );
    wire [19:0] frequency;
    reg [19:0] pastFrequency = 0;
    reg [5:0] c_counter = 0;
    reg [5:0] fAVG_counter = 0;
    reg beginCalc = 0;
    reg [26:0] result = 0;
    wire [19:0] frequencyAVG; 
getFreq getFq(
.CLK100MHZ(CLK100MHZ),
.signal(signal),
.frequency(frequency)
);

//TODO: take average of input for 1ms and put that into frequency.
//Done so with FAVG_counter.
//
always @ (posedge CLK100MHZ) begin
    
    if (pastFrequency != frequency) begin
       // fAVG_counter <= fAVG_counter +1;
        result <= frequency;
        pastFrequency <= frequency;
        beginCalc <= 1;
    end else begin // prevents the inferring of latches
            c_counter <= c_counter;
            pastFrequency <= frequency;
            beginCalc <= beginCalc;
        end
    
    if(beginCalc) begin
    
    end    
   // if(fAVG_counter >= 1_000_000_000) begin//added 2:15
    case(1)
        1: begin counter <= c_counter[5:0]; freq <= frequency[19:4]; end
    endcase
   // end//added 2:15
end


endmodule
