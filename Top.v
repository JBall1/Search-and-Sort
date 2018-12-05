`timescale 1ns / 1ps

module Top(
    input clk,
   // input [1:0] SW,
    input Pulse,
    //input Start,
    input Clear,
    output reg [3:0] ColorDis,
    output reg S2,
    output reg S3//,
//    output reg [3:0] Digit = 3'b111,
//    output reg [6:0] Segment = 7'b1111111
    );
   
    wire ColorS2;
    wire ColorS3;
//    wire [3:0]DigitWire;
//    wire [6:0] SegmentWire;
    wire [7:0] ColorOut;
    wire [7:0] RedDiv;
    wire [7:0] BlueDiv;
    wire [7:0] GreenDiv;
    reg [7:0] ColorPerc;
    reg RunSample = 0;
   // reg [3:0] ColorDis;
    wire TestDone;
   
    
    color Run(
        .Selector1(ColorS2),
        .Selector2(ColorS3),
        //.ColorOut(ColorOut),
        .Run(RunSample),
        .RedDiv(RedDiv),
        .BlueDiv(BlueDiv),
        .GreenDiv(GreenDiv),
        .TestDone(TestDone),
        .clk(clk),
        .Pulse(Pulse)
    );
    
//    Disp Color(
//        .Dig(DigitWire),
//        .Seg(SegmentWire),
//        .clk(clk),
//        .Input(ColorPerc),
//        .ColorInput(ColorDis)
//    );
    
    
    always @(posedge clk)
    begin
        S2 = ColorS2; // wire connecting S2 output to the output form the color module
        S3 = ColorS3; // wire connecting S3 output to the output form the color module
        //Digit = DigitWire; // wire connecting the display module to the sements 
        //Segment = SegmentWire; // wire connecting the display module to the digits
    end
    
    always @(posedge clk) // this controls the LED and buttons 
    begin
        if (1) // if the start button is pressed starts the color module
        begin 
            RunSample = 1;
        end
        if (Clear) // if clear is pressed clears out the color module
        begin
            RunSample = 0;
        end
    end
    
    always @(posedge clk) // controls what the display is showing
    begin
//        case(SW) // a case based on the state of the switches
//        2'b00: // shows the red percentage
//        begin
//            ColorPerc <= RedDiv;
//            ColorDis <= 0;
//        end
//        2'b01: // shows the blue percentage
//        begin
//            ColorPerc <= BlueDiv;
//            ColorDis <= 1;
//        end
//        2'b10: // shows the green percentage
//        begin
//            ColorPerc <= GreenDiv;
//            ColorDis <= 2;
//        end
//        2'b11: // show what color was found by the color module
//        begin
            ColorPerc <= 0; // zeros out the color percent reg so that is shows all zeros
            case(ColorOut)
            3'b100: // display unknown
            begin
                ColorDis <= 4;
            end
            3'b000: // display red
            begin
                ColorDis <= 0;
            end    
            3'b001: // display blue
            begin
                ColorDis <= 1;
            end
            3'b010:
            begin // display green
                ColorDis <= 2;
            end
            3'b011: // display yellow
            begin
            ColorDis <= 3;
            end
            endcase
        end
        //endcase
        
endmodule
