`timescale 1ns / 1ps
//Frequency Counter module designed for the Color Sensor. Can be used in multiple sencarios but was found to be best for TSC3200 only.

module FreqCounter(
    input CLK,
    input Pulse, // form the sensor
    input Start, // starts the module
    output reg [9:0] Freq = 25'b0, // output of the frequancy found
    output reg Finished = 0 // lets the color module know when this module is done
    );
    
    reg [31:0] ClkCount = 32'b0; // keeps count of how many pos edges from the colock
    reg [9:0] FreqCount = 25'b0; // keeps count of the pos edges found form the sensor
    reg last = 1'b0; // tracks the last state from the sensor
    reg meta = 1'b0; // catches the meta state error
    reg sync = 1'b0; // current stat of the sensor
    
    localparam max = 32'd6_250_000; // the number of pos edges from the clock in 1/16th of a second
    
    always @ (posedge CLK) // reads in the pulse form the sensor and syncs it to the clock
    begin
      if (Start) // when the module is told to start
      begin
        meta <= Pulse; // sets the meta state to that of the pulse
        sync <= meta; // updates the state of sync with the state of meta
        last <= sync; // stors the previus state of sync in last
      end
      else // when the moudle is clears zeros out the flip flops
      begin 
        meta = 0;
        sync = 0;
        last = 0;
      end
    end
        
    always @ (posedge CLK)
    begin
        if (~Start) // clears out the reg when the module is told to stop
        begin
            Freq <= 0;
            ClkCount <= 0;
            FreqCount <= 0;
            Finished <= 0;
        end
        else
        begin
            if (ClkCount < max) // wile the count is less than max
            begin
                 if (sync == 1 && last == 0) // test to see if the current stat is high and last state was low this is a rising edge
                 begin
                      FreqCount <= FreqCount + 1; // add one to the frequancy count
                      ClkCount <= ClkCount + 1; // add one to the clock count
                 end
                 else
                 begin
                      ClkCount <= ClkCount + 1; // if no pos edge was found just add one to the clock count
                 end
            end
            else // when max is reached multiply the frequancy count by 16 to find the number of pulses per second and set finished to 1 
            begin
                Freq <= FreqCount;
                Finished <= 1;
            end
         end
      end
    
endmodule
