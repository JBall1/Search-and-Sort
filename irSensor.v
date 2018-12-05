`timescale 1ns / 1ps

module irSensor(
    input CLK100MHZ,
    input ir_FLAG,
    
    //output reg ir_VAL,
    output reg [1:0] iFlag
    );
    
    reg [25:0] counter = 26'd0;    //  Counter variable
    parameter loop_count = 26'd30000000;   
    parameter timerFlag   = 26'd1000;      // 10 microseconds
    
    reg [25:0] count = 26'd0;       
    parameter maxThreshold = 26'd300000; //max time
    
    always @ (posedge CLK100MHZ) begin
    
    if (counter < timerFlag) begin
        count <= 0;
       // ir_VAL <= 1;
        counter <= counter + 1;
    end else if (counter < loop_count) begin
        //ir_VAL <= 0;
        counter <= counter + 1;
        
        if (ir_FLAG) begin
            count <= count + 1;
        end
        
        //reset vals
        end else begin
        counter <= 24'd0;
       // ir_VAL <= 0;
        
        if (count < maxThreshold) begin
       //if(ir_VAL) begin
            iFlag <= 2'b10;
            end
        else
            iFlag <= 2'b01;
    end
    end
endmodule
