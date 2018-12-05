`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2018 02:10:10 PM
// Design Name: 
// Module Name: Disp
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


module Disp(
    input  clk,
    input [7:0] Input, // this is the percentage
    input [3:0] ColorInput, // this is the color that was found by the color module
    output reg [3:0] Dig, // controls what digit is on
    output reg [6:0] Seg // controls the segments of the digits
    );
    
    reg [1:0] CaseDis = 0; // controls what digit is on
    reg [17:0] CountDown = 0; // controls how long before turning on the next digit
    reg [3:0] NumOut = 0; // this is the state that is used to turn on the segments
    reg [3:0] ColorType; // input from the top module that shows what color was found by the color module
    reg [11:0] bcd = 0;
    reg [3:0] i = 0;
    reg [3:0]BCDCase = 0;
    reg [7:0] Perc = 0;
    reg [11:0] BCDOut = 0;
    
    localparam max = 'd195312; // how long each digit will be turned on for, about 1/500th of a second
    
    always @(posedge clk)
    begin
        ColorType = ColorInput; // sets the input form the top module to this reg
        if (CountDown > max) // when max is reached switches to the next digit to be turned on
        begin
            CaseDis = CaseDis + 1; // adds one to the case called CaseDis that controls what digit is to tbe turned on
            CountDown = 0; // resets the count to 0
        end
        else
        begin
            CountDown = CountDown + 1; // if max has not been reached adds one to the count
        end
        case (BCDCase)
        0:
        begin
            Perc <= Input;
            bcd <= 0;
            i <= 0;
            BCDCase <= 1;
        end
        1:
        begin
            bcd[0] <= Perc[7];
            BCDCase <= 2;
            i <= i + 1;
        end
        2:
        begin
            if (i == 8)
            begin
                BCDCase <= 4;
            end
            else
            begin
                if (bcd[7:4] >= 5)
                    bcd <= bcd + 48;
                if (bcd[3:0] >= 5)
                    bcd <= bcd + 3;
                BCDCase <= 3;
            end
        end
        3:
        begin
            bcd <= bcd << 1;
            Perc <= Perc << 1;
            BCDCase <= 1;
        end
        4:
        begin
            BCDOut = bcd;
            BCDCase <= 0;
        end
        endcase
    end
    
    always @(posedge clk) // controls the outputs
    begin
        case (CaseDis) // case for the digits
        2'b00: // first digit that is the color type r, b, G, Y, u
            begin
                Dig = 4'b0111;
                NumOut = 4'b1010; // this sets the case to show the leter based on an input form the top module
            end
        2'b01: // third digit
            begin
                Dig = 4'b1011;
                NumOut = BCDOut[11:8];
            end
        2'b10: // controls the second digit 
            begin
                Dig = 4'b1101;
                NumOut = BCDOut[7:4];
            end
        2'b11: // first digit
            begin
                Dig = 4'b1110; 
                NumOut = BCDOut[3:0];
            end
        endcase
        end

    always @(*) // contains the case statment that controls binary number written to the segments
    begin
        case (NumOut) // list of 0 - 9
        4'b0000: Seg = 7'b0000001; // 0
        4'b0001: Seg = 7'b1001111; // 1
        4'b0010: Seg = 7'b0010010; // 2
        4'b0011: Seg = 7'b0000110; // 3
        4'b0100: Seg = 7'b1001100; // 4
        4'b0101: Seg = 7'b0100100; // 5
        4'b0110: Seg = 7'b0100000; // 6
        4'b0111: Seg = 7'b0001111; // 7
        4'b1000: Seg = 7'b0000000; // 8
        4'b1001: Seg = 7'b0000100; // 9
        4'b1010: // this case is used to write out the leters r, b, G, Y, u
        begin
            if (ColorType == 0) // if color is red
            begin
                Seg = 7'b1111010;
            end
            else if (ColorType == 1) // if color is blue
            begin
                Seg = 7'b1100000;
            end
            else if (ColorType == 2) // if color is green
            begin
                Seg = 7'b0100001;
            end
            else if (ColorType == 3) // yellow
            begin 
                Seg = 7'b1001100;
            end
            else if (ColorType == 4) // unknown
            begin
                Seg = 7'b1100011;
            end
        end
        default: Seg = 7'b0000001; // if the case does not match any of the given number then ouputs 0
        endcase
    end
    
    
endmodule
