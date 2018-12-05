`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2018 02:14:19 PM
// Design Name: 
// Module Name: FreqDiv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FreqDiv(
    input clk,
    input [9:0] Freq, // input color frequency
    input [9:0] Clear, // input clear frequency
    input Start, // starts the module
    output reg [7:0] Perc, // output the precentage found
    output reg Done // output when the module is done
    );
    
    reg [17:0] Num = 0; // numerator that is the color frequency
    reg [9:0] Dem = 0; // denominator that is the clear freqeuncy
    reg [7:0] Count = 0; // keeps track of how many times the denominator can be subtracted form the numerator
    reg [1:0] State = 2'b00; // case state
    
    always @ (posedge clk)
    begin
        if (~Start) // if the module is stoped clear out the reg
        begin
            Num = 0;
            Dem = 0;
            Perc = 0;
            State = 2'b00;
            Count = 0;
            Done = 0;
        end
        else
        begin
        case (State)
            2'b00: // loads the reg 
            begin
                if ((Freq >= 0) && (Clear >= 0)) // test to see if the clear freq is greater than 0
                begin
                    Dem = Clear; // loads the clear frequency into the dem reg
                    Num = (Freq * 100) + (Clear / 2); // multiplies the color frequency by 100 to find the precentage
                    State = 2'b01; // moves to the next state
                end
            end
            2'b01: // subtracts Dem form Num
            begin
                if (Num >= Dem) // as long as Num is larger 
                begin
                    Num = Num - Dem; // subtracks Dem from Num
                    Count = Count + 1; // adds one to the count
                end
                else 
                begin
                    State = 2'b10; // onces Num is less than Dem goes to the next state
                end
            end
            2'b10: // outputs the precentage and lets the top module know this module is done
            begin
                Perc = Count;
                Done = 1;
            end
       endcase 
       end    
    end
    
endmodule
