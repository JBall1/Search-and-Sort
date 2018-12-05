`timescale 1ns / 1ps
 
module ultraSonic(
input CLK100MHZ,
input echo,
output reg trig,
output reg [1:0] choose

);

//  Registers
reg [25:0] counter = 26'd0;    //  Counter variable
parameter loop_count = 26'd30000000;   //  65 ms measurement loop
parameter trig_end   = 26'd1000;      //  1000 clock ticks = 10 microseconds

reg [25:0] echo_count = 26'd0;       //  Duration of echo pulse
parameter threshold = 26'd300000;    //  Any pulse lower than this indicates an obstacle

//  Clock edge procedure
always @ (posedge CLK100MHZ) begin
    
    //Pulse generation loop
    if (counter < trig_end) begin   //1 10 microsecond trig pulse
        echo_count <= 0;
        trig <= 1;
        counter <= counter + 1;
    end else if (counter < loop_count) begin
        trig <= 0;
        counter <= counter + 1;
        
        if (echo) begin
            echo_count <= echo_count + 1;
        end
        
    end else begin
        //  Once counter goes over, reset everything
        counter <= 24'd0;
        //  Reset variables as well
        trig <= 0;
        
        if (echo_count < threshold)
            choose <= 2'b01;
        else
            choose <= 2'b10;
    end
    
end

endmodule

