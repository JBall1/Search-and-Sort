`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2018 01:48:05 PM
// Design Name: 
// Module Name: color
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


module color(
    output reg Selector1, // S2
    output reg Selector2, // S3
    output reg [2:0] ColorOut, // output for what color was found
    output reg TestDone, // outputs when the module is done
    output reg [7:0] RedDiv, // outputs the percentage for red
    output reg [7:0] BlueDiv, // outputs the percentage for blue
    output reg [7:0] GreenDiv, // outputs the percentage for green
    input clk, // input for the clock
    input Pulse, // input form the sensor
    input Run // tells the module to run
    );
    
    initial
    begin
    ColorOut = 0;
    Selector1 = 1;
    Selector2 = 0;
    TestDone = 0;
     RedDiv = 0;
     BlueDiv = 0;
     GreenDiv = 0;   
    end
    
    wire [9:0] FreqMod; // wire links the frequency form the coutner module
    reg [9:0] ClearFreq = 0; // stores the clear frequency
    reg StartCount = 0; // reg that controls when the counter module starts and stops
    reg StartDiv = 0; // reg that controls when the division module starts and stops
    wire DoneFreq; // wire that show swhen the coutner module is done
    wire DivDone; // wire that shows when the division module is done
    reg [3:0] State = 4'b0000; // case statement
    wire [7:0] Perc; // wire that shows the precentage found by the division module
    reg [1:0] RedCount = 0; // keeps track of how many times red was found
    reg [1:0] GreenCount = 0; // keeps track of how many times Green was found
    reg [1:0] BlueCount = 0; // keeps track fo how many times blue was found
    reg [1:0] YellowCount = 0; // keeps track of how many times yellow was found
    reg [1:0] UnknownCount = 0; // keeps track of how many times nothing was found
    
    FreqCounter freq(
        .CLK(clk),
        .Pulse(Pulse),
        .Start(StartCount),
        .Freq(FreqMod),
        .Finished(DoneFreq)
    );
    
    FreqDiv Div(
        .clk(clk),
        .Freq(FreqMod),
        .Clear(ClearFreq),
        .Start(StartDiv),
        .Perc(Perc),
        .Done(DivDone)
    );
    
    always @ (posedge clk) 
    begin
        if (~Run) // when the module is stopped clear out all the registries and set the state to the starting position
        begin
            ColorOut <= 4;
            RedCount <= 0;
            RedDiv <= 0;
            BlueCount <= 0;
            BlueDiv <= 0;
            GreenCount <= 0;
            GreenDiv <= 0;
            YellowCount <= 0;
            UnknownCount <= 0;
            TestDone <= 0;
            Selector1 <= 1;
            Selector2 <= 0;
            State <= 4'b0000;
        end
        else
        begin
        case(State)
            4'b0000: // gets the clear freq
            begin
               StartCount <= 1; // starts the freq counter module
               if (DoneFreq == 1) // when the freq counter module is done
               begin
                    ClearFreq <= FreqMod; // sotres the freq found by the module in the clear freq reg
                    StartCount <= 0; // clears the freq module
                    StartDiv <= 0;
                    State <= 4'b0001; // moves to the next state to read in the green perc
                    Selector1 <= 1; // sets S2 to 1
                    Selector2 <= 1; // sets S3 to 1 
               end
            end
            4'b0001:
            begin
                if (DoneFreq == 0)
                    State <= 4'b0010;
            end            
            4'b0010: // getst he freq for green
            begin
               StartCount <= 1; // starts the freq counter module    
               if (DoneFreq == 1) // when the freq coutner module is done
               begin
                    StartDiv <= 1;
                    if (DivDone == 1)
                    begin
                         GreenDiv <= Perc; // stores the percentage in greenDiv reg
                         StartCount <= 0; // clears the counter module
                         StartDiv <= 0;
                         State <= 4'b0011; // moves to the next state
                         Selector1 <= 0; // sets S2 to 0
                         Selector2 <= 1; // sets S3 to 1
                    end
               end
            end
            4'b0011:
            begin
                if (DivDone == 0 && DoneFreq == 0)
                    State <= 4'b0100;
            end
            4'b0100: // getst he freq for blue
            begin
               StartCount <= 1; // start the freq counter module
               if (DoneFreq == 1) // when the coutner module is done
               begin
                    StartDiv <= 1;
                    if (DivDone == 1)
                    begin
                        BlueDiv <= Perc; // store the precentage form the division module 
                        StartCount <= 0; // clear the counter module
                        StartDiv <= 0;
                        State <= 4'b0101; // move to the next state to read in the red percentage
                        Selector1 <= 0; // set S2 to 0
                        Selector2 <= 0; // set S3 to 0
                    end
               end
            end
            4'b0101:
            begin
                if (DivDone == 0 && DoneFreq == 0)
                    State <= 4'b0110;
            end
            4'b0110: // gets the freq for red
            begin
               StartCount <= 1;// start the freq counter module
               if (DoneFreq == 1) // when the coutner module is done
               begin
                   StartDiv <= 1;
                   if (DivDone == 1)
                   begin
                        RedDiv <= Perc; // store the percentage form the division module
                        StartCount <= 0; // clear the counter modlue
                        StartDiv <= 0;
                        State <= 4'b0111; // move to the next state to find the color base on the percentages
                        Selector1 <= 1; // set S2 to 1
                        Selector2 <= 0; // set S3 to 0 to read in the clear frequency
                   end
               end
            end
             4'b0111:
            begin
                if (DivDone == 0 && DoneFreq == 0)
                    State <= 4'b1000;
            end
            4'b1000: // this checks the percentages found against a set range to determen what the color is
            begin
                if ((BlueDiv >= 35 && BlueDiv <= 37) && (GreenDiv >= 24 && GreenDiv <= 25) && (RedDiv >= 32 && RedDiv <= 37)) // if red
                begin
                    RedCount <= RedCount + 1; // add one to the red count
                    State <= 4'b1001; 
                end
                else if ((BlueDiv >= 40 && BlueDiv <= 42) && (GreenDiv >= 25 && GreenDiv <= 27) && (RedDiv >= 25 && RedDiv <= 28)) // if blue
                begin
                    BlueCount <= BlueCount + 1; // add one to the blue count
                    State <= 4'b1001; 
                end
                else if ((BlueDiv >= 37 && BlueDiv <= 39) && (GreenDiv >= 25 && GreenDiv <= 27) && (RedDiv >= 28 && RedDiv <= 30)) // if green
                begin
                    GreenCount <= GreenCount + 1; // add one to the green count 
                    State <= 4'b1001; 
                end
                else if ((BlueDiv >= 35 && BlueDiv <= 36) && (GreenDiv >= 27 && GreenDiv <= 28) && (RedDiv >= 31 && RedDiv <= 33)) // if yellow 
                begin
                    YellowCount <= YellowCount + 1; // add one to the yellow count
                    State <= 4'b1001; 
                end
                else  // unknown
                begin
                    UnknownCount <= UnknownCount + 1; // if the percentages do not match any of the given ranges then add one to uknown
                    State <= 4'b1001; 
                end
            end
            4'b1001: // this test to see if 3 of any color was found 
            begin
                if (RedCount == 3) // if red was found 3 times then sets the output of colorout to as red 
                begin
                    ColorOut <= 0; // colourout is to tell the top moudle what color was found
                    State <= 4'b1010; // moves to the next state
                end
                else if (BlueCount == 3)
                begin
                    ColorOut <= 1;
                    State <= 4'b1010;
                end
                else if (GreenCount == 3)
                begin
                    ColorOut <= 2;
                    State <= 4'b1010;
                end
                else if (YellowCount == 3)
                begin
                    ColorOut <= 3;
                    State <= 4'b1010;
                end
                else if (UnknownCount == 3)
                begin
                    ColorOut <= 4;
                    State <= 4'b1010;
                end
                else
                begin
                    State <= 4'b0000; // if none of the counts are 3 goves back to the start of the case and rereads in the frequancies and tests them again
                end
            end
            4'b1010: // once one of the counts is at 3 this state outputs that the test was done to the top module
            begin
                TestDone <= 1;
            end
         endcase
         end
    end   
endmodule
