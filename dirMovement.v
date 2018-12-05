`timescale 1ns / 1ps

module dirMovement(
input CLK100MHZ,
input [2:0] movementCommand,
output reg [3:0] motor = 4'b1111 
    );
    always @(posedge CLK100MHZ) begin
        case(movementCommand) 
            3'b000: motor <= 4'b1001; // Forward
            3'b001: motor <= 4'b0110; // Back
            3'b010: motor <= 4'b1111; // Stop
            3'b011: motor <= 4'b0000; //Slow stop?
            3'b100: motor <= 4'b0101; // Left
            3'b101: motor <= 4'b1010; // Right
            3'b110: motor <= motor; // do what was previous
            3'b111: motor <= motor; // do what was previous
            default: motor <= 4'b1111; // default to Stop
        endcase
    end
 endmodule

