`timescale 1ns / 1ps

//Main movement module for tank. Based on current speed wanted/needed,  it will assigned the needed duty cycle for the motors.
//Can be changed to have a speed for each motor with a few small changes.

module movementMain(
	input CLK100MHZ,
	input reset,
	input [2:0] movementCommand, 
	input [1:0] curSpeed,
	input [1:0] speedChange,
	output enableA,
	output enableB,
	output [3:0] motor

);
reg [4:0] dutyCycle;

//assign curSpeed = 1;

PWM powa(
.CLK100MHZ(CLK100MHZ),
.speed(dutyCycle),
.reset(reset),
.pwm_1(enableA),
.pwm_2(enableB)
);

dirMovement SetDirection(
.CLK100MHZ(CLK100MHZ),
.movementCommand(movementCommand),
.motor(motor)
);

always @(*) begin
     if (speedChange == 2'b00) begin
		case(curSpeed)
			0: dutyCycle <= 5'b00000; // 0%
			1: dutyCycle <= 5'b00111; // 20%
			2: dutyCycle <= 5'b01101; // 40%
			3: dutyCycle <= 5'b10011; // 60%
		endcase
     end
     else if (speedChange == 2'b11) begin
             dutyCycle <= 5'b00000; // 0%
     end
	
end       

endmodule
