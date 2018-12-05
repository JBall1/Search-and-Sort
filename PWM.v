`timescale 1ns / 1ps

module PWM(
    input [4:0] speed,
    input reset,
    input CLK100MHZ,
    output pwm_1,
    output pwm_2
    );
    
    reg [18:0] counter;
    reg [18:0] width;
    reg temp_PWM;
    
    initial begin
        counter = 0;
        width = 0;
        temp_PWM = 0;
    end
    

    
    always@(posedge CLK100MHZ) begin
        if(reset)
            counter <= 0;
        else
            counter <= counter + 1;
        
        if (counter < width)
            temp_PWM <= 1;
        else
            temp_PWM <= 0;
    end
    
    always @ (*) begin
        case (speed)
			5'd0 : width = 19'd0; 
        5'd1 : width = 19'd15625; // 25% Duty Cycle
        5'd2 : width = 19'd31250; // 50% Duty Cycle
        5'd3 : width = 19'd46875; // 75% Duty Cycle
    
        5'd4 : width = 19'd62500; 
        5'd5 : width = 19'd78125; // 25% Duty Cycle
        5'd6 : width = 19'd93750; // 50% Duty Cycle
        5'd7 : width = 19'd109375; // 75% Duty Cycle
    
        5'd8 : width = 19'd125000; 
        5'd9 : width = 19'd140625; // 25% Duty Cycle
        5'd10 : width = 19'd156250; // 50% Duty Cycle
        5'd11 : width = 19'd171875; // 75% Duty Cycle
        
        5'd12 : width = 19'd187500; 
        5'd13 : width = 19'd203125; // 25% Duty Cycle
        5'd14 : width = 19'd218750; // 50% Duty Cycle
        5'd15 : width = 19'd234375; // 75% Duty Cycle
        
        5'd16 : width = 19'd250000; 
        5'd17 : width = 19'd265625; // 25% Duty Cycle
        5'd18 : width = 19'd281250; // 50% Duty Cycle
        5'd19 : width = 19'd296875; // 75% Duty Cycle
    
        5'd20 : width = 19'd312500; 
        5'd21 : width = 19'd328125; // 25% Duty Cycle
        5'd22 : width = 19'd343750; // 50% Duty Cycle
        5'd23 : width = 19'd359375; // 75% Duty Cycle
    
        5'd24 : width = 19'd375000; 
        5'd25 : width = 19'd390625; // 25% Duty Cycle
        5'd26 : width = 19'd406250; // 50% Duty Cycle
        5'd27 : width = 19'd421875; // 75% Duty Cycle
        
        5'd28 : width = 19'd437500; 
        5'd29 : width = 19'd453125; // 25% Duty Cycle
        5'd30 : width = 19'd468750; // 50% Duty Cycle
        5'd31 : width = 19'd524287; // 100% duty cycle
            
    endcase 
    end
    assign pwm_1 = temp_PWM;
    assign pwm_2 = temp_PWM;
    
endmodule
