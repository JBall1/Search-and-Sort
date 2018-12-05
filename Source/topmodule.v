//Top module used to control all other modules within the project.
//Contains base logic("State machine") for the movement and control of the tank.


//TODO: proper turning in state machine.
//      ADD electromagnet switch(1 or 0?)
`timescale 1ns / 1ps
module topmodule (   
    input CLK100MHZ, //clock
    output [7:0] seg, //segments for display 
    output [3:0] an,//enables for display
    
    output  enableA_motor,
    output  enableB_motor,
    output [3:0] motorInput,//IN1-IN4
    
    input [1:0] speedChange,
    input sw0,
    input sw1,
    input sw2,
    input sw3,
    output led0,
    output led1,
    output led2,
    output led3,
    output led4,
    //IR sensor
    input irPing_front,
    output [1:0] irFlag_front,
//    output irOUT_front,
    
    input irPing_left,
    output [1:0] irFlag_left,
    //output irOUT_left,
    
    input irPing_right,
    output [1:0] irFlag_right,
//    output irOUT_right,
    
    //metal detector
    input metalVal,
    
    //magnet
    output reg magnetON,
    //Color Sensor
    input colorSensorPulse,
    input  colorSensor_S2,
    input  colorSensor_S3,
    
    //frequency input from phototransistor
    input inputSignal
    );
    assign led0 = sw0;
    assign led1 = sw1;
    assign led2 = sw2;
    assign led3 = ~metalVal;
    assign led4 = ~irPing_right;
    
    reg tmp_clk;
reg[3:0] washerColorValue;
wire [15:0] displayed_number;
reg [15:0] displayed_number_2;
parameter frontTimer = 250000000; //2.5 seconds
parameter leftTimer = 250000000; //2.5 seconds
parameter rightTimer = 250000000; //2.5 seconds
reg[29:0] flagFront = 0;
reg[29:0] flagRight = 0;
reg[29:0] flagLeft = 0;
reg[29:0] counter_100Meg_wire;
reg[32:0] dist_counter=0;
reg [18:0] counter;
reg [18:0] counter_2;
reg reset = 0;
reg [4:0] dutyCycle;
reg [1:0] speed = 1;
reg[1:0] getColor = 0;
//state regs
reg[4:0] searchingState_WASHER = 4'd01;
reg[4:0] searchingState_LED = 4'd02;
reg[4:0] obstacleAvoidanceState_RIGHT = 4'd03;
reg[4:0] obstacleAvoidanceState_LEFT = 4'd07;
reg[4:0] obstacleAvoidanceState_FRONT = 4'd08;
reg[4:0] gettingWasherColorState = 4'd04;
reg[4:0] pickingUpWasherState = 4'd05;
reg[4:0] checkingLEDFrequency = 4'd06;
reg[4:0] dropWASHER = 4'd09;
//state holders
reg[4:0] currentState;
reg[4:0] previousState;

wire [5:0] ccounter = 0;
reg [5:0] c_counter = 0;

reg[1:0] washerCounter = 4'd00;
reg[1:0] second = 0;
//movement values per truth table:
parameter forward = 3'b000;
parameter backwards = 3'b001;
parameter stop1 = 3'b010;
parameter stop2 = 3'b011;
//movement values
parameter left = 3'b100;
parameter right = 3'b101;


reg [2:0] direction = 0;
reg[1:0] LEDColor;
parameter UNKNOWN = 0;
parameter RED = 1;
parameter BLUE = 2;
parameter GREEN = 3;
parameter YELLOW = 4;
reg [1:0] lastTurn = 2'd00;
reg [1:0] lastTurn_RIGHT = 2'd01;
reg [1:0] lastTurn_LEFT = 2'd02;
reg obstacleRight = 1;
reg[1:0] dir = 1;
//reg[1:0] irFlag_right;
//reg[1:0] irFlag_left;
//reg[1:0] irFlag_front;
Display display(
.outputVal(displayed_number_2),
.CLK100MHZ(CLK100MHZ),
.sseg(seg),
.enables(an)
);

movementMain movement(
.CLK100MHZ(CLK100MHZ),
.reset(reset),
.motor(motorInput),
.movementCommand(direction),
.enableA(enableA_motor),
.enableB(enableB_motor),
.curSpeed(speed),
.speedChange(speedChange)
);

irSensor infraredFront (
.CLK100MHZ(CLK100MHZ),
.ir_FLAG(irPing_front),
//.ir_VAL(irOUT_front),
.iFlag(irFlag_front)
);

irSensor infraredRight (
.CLK100MHZ(CLK100MHZ),
.ir_FLAG(irPing_right),
//.ir_VAL(irOUT_right),
.iFlag(irFlag_right)
);

irSensor infraredLeft (
.CLK100MHZ(CLK100MHZ),
.ir_FLAG(irPing_left),
//.ir_VAL(irOUT_left),
.iFlag(irFlag_left)
);

freqControl senseFreq(
.CLK100MHZ(CLK100MHZ),
.freq(displayed_number),
.signal(inputSignal),
.counter(ccounter)//,
//.Color(LEDColor)
);
Top colorSensorControl( 
.clk(CLK100MHZ),
////input [1:0] SW,
.Pulse(colorSensorPulse),
//.Start(getColor),
////input Clear,
.S2(colorSensor_S2),
.S3(colorSensor_S3)//,
////output reg [3:0] Digit = 3'b111,
////output reg [6:0] Segment = 7'b1111111,
////output reg TestDoneLED = 0  
);  
initial begin
counter = 0;
c_counter = 0;
counter_100Meg_wire <= 0;
end

//catches flags and sets state to appropriate value
always @ (posedge CLK100MHZ) begin  
//if(washerCounter == 4) begin
// direction = stop1;
// speed = 0;
//end
 //currentState <= searchingState_WASHER;
    //if we are looking for an LED and we found one
    if((irFlag_right == 2'b01 && irFlag_front == 2'b01 || irFlag_left == 2'b01 && irFlag_front == 2'b01)) begin
        //currentState <= checkingLEDFrequency;
        //washer found
    end else if(metalVal) begin
        currentState <= gettingWasherColorState;
        
        //directly front
    end else if(irFlag_front == 2'b01) begin
    
//    if(counter_100Meg_wire > 0  && counter_100Meg_wire < 40000000) begin
//                            speed = 3;
//                            direction = left;                         
//              end
//else if(counter_100Meg_wire > 40000000  && counter_100Meg_wire < 70000000) begin
//                                      speed = 3;
//                                      direction = forward;                         
//                        end

        currentState <= obstacleAvoidanceState_FRONT;
         //left corner
    end else if(irFlag_right == 2'b01 && irFlag_front == 2'b01) begin
                 currentState <= obstacleAvoidanceState_RIGHT;
                 //right corner
    end else if(irFlag_left == 2'b01 && irFlag_front == 2'b01) begin
                 currentState <= obstacleAvoidanceState_LEFT;
     end else if (currentState == checkingLEDFrequency) begin
            currentState <= dropWASHER;
    end
     
     else begin
    currentState <= searchingState_WASHER; 
 end   
end
//counter
always @ (posedge CLK100MHZ) begin
if(!reset) begin
            counter_100Meg_wire <= counter_100Meg_wire + 1;    
end
//            speed = 3;
//direction <= forward;   
case(currentState)
//search pattern
searchingState_WASHER:
    begin
                                   speed = 3;
    direction = forward; 
            //displayed_number_2 <= 16'b0000_0000_0000_0000;
            //displayed_number_2 <= 16'b0000_0000_0000_1111;
            lastTurn <= lastTurn_LEFT;
 if(counter_100Meg_wire > 400000000 && counter_100Meg_wire < 600000000 ) begin
                                       speed = 3;
                                       direction = right;   
            
        end
           
            //after going forward in search pattern..
                if(lastTurn == lastTurn_LEFT) begin
                lastTurn <= lastTurn_RIGHT;
                //short duration turn to go forward again
                    if(counter_100Meg_wire > 0 && counter_100Meg_wire < 400000000) begin
                                              speed = 3;
                                               direction = left;
                                               counter_100Meg_wire <= 0;

                    end
                    else if(lastTurn == lastTurn_RIGHT) begin
                                  lastTurn <= lastTurn_LEFT;
                                if(counter_100Meg_wire > 0 && counter_100Meg_wire < 400000000) begin
                                        speed = 3;
                                        direction = right;
              
                                 end end

                end //end
               
            end 
//washer detected
gettingWasherColorState:
    begin
    magnetON = 1;
        //displayed_number_2 <= 16'b0000_0000_1111_0000;
        speed = 0;
        //direction = stop1;
       if(counter_100Meg_wire > 0 && counter_100Meg_wire < 200000000) begin
                           speed = 3;
                           direction = forward; 
             end
        case(washerColorValue)
        3'b100: // display unknown
        begin
        LEDColor <= UNKNOWN;
         displayed_number_2 = 16'b1111_1111_1111_1111;
        end
        3'b000: // display red
        begin
                 displayed_number_2 = 16'b1111_0000_0000_1111;

        LEDColor <= RED;
        end    
        3'b001: // display blue
        begin
        LEDColor <= BLUE;
                         displayed_number_2 = 16'b1100_0000_0000_0011;

        end
        3'b010:
        begin // display green
        LEDColor <= GREEN;
                         displayed_number_2 = 16'b0000_0000_0000_0001;

        end
        3'b011: // display yellow
        begin
        LEDColor <= YELLOW;
                         displayed_number_2 = 16'b0000_0000_0001_0001;

        end
       
        endcase
                                         speed = 3;
        direction = forward;
//        if(LEDColor == UNKNOWN) begin
         if(counter_100Meg_wire > 50000000 && counter_100Meg_wire < 70000000 ) begin

                       
//                    end
              direction = stop1;
               
        case(washerColorValue)
                
        3'b100: // display unknown
        begin
        LEDColor <= UNKNOWN;
        //currentState <= previousState;
        end
        3'b000: // display red
        begin
        LEDColor <= RED;
       // currentState <= searchingState_LED;
        end    
        3'b001: // display blue
        begin
        LEDColor <= BLUE;
       // currentState <= searchingState_LED;
        end
        3'b010:
        begin // display green
        LEDColor <= GREEN;
       // currentState <= searchingState_LED;
        end
        3'b011: // display yellow
        begin
        LEDColor <= YELLOW;
        
        end
            endcase 
           
           end end
//SearchingState LED    
//searchingState_LED: 
//    begin
//dir = 1;//1 is left, 2 is right. Previous turn
//if(counter_100Meg_wire > 0 && counter_100Meg_wire < 100000000) begin
//          speed = 3;
//          direction = forward; 
//          dir = 1;
//end if(dir == 1 && counter_100Meg_wire > 100000000 && counter_100Meg_wire < 500000000 && irFlag_left == 2'b01 && irFlag_front == 2'b01 ) begin
//    speed = 3;
//    direction = right; 
//    dir = 2;
//end else if(dir == 2 && counter_100Meg_wire > 100000000 && counter_100Meg_wire < 500000000 && irFlag_right == 2'b01 && irFlag_front == 2'b01 ) begin
//        speed = 3;
//        direction = left; 
//        dir = 1;
//    end


//    end
dropWASHER:
begin
//displayed_number_2 <= 16'b0000_1111_0000_0000;
//if(inputSignal) begin
    speed = 0;
    direction = stop1;
    magnetON = 0;
    //currentState <= searchingState_WASHER;
        direction = forward;
    speed = 3;
    end
//end

obstacleAvoidanceState_FRONT:
begin
                        speed = 3;
direction = left;           
if(counter_100Meg_wire > 50000000  && counter_100Meg_wire <70000000 ) begin
                                      speed = 3;
direction = forward;    
          end
//          currentState <= searchingState_WASHER;

          end





obstacleAvoidanceState_RIGHT:
begin
//displayed_number_2 <= 16'b1001_1001_1001_1001;
speed = 3;
direction = left; 
if(counter_100Meg_wire > 40000000 && counter_100Meg_wire < 50000000) begin
    speed = 3;
direction = forward; 

end 
//currentState <= searchingState_WASHER;

end
obstacleAvoidanceState_LEFT:
begin
  speed = 3;
direction = right; 
if(counter_100Meg_wire > 0 && counter_100Meg_wire < 40000000) begin
 speed = 3;
direction = forward; 
end
//currentState <= searchingState_WASHER;

end
   endcase
   end
endmodule
