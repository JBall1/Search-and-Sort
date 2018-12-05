#constraints file

# Clock signal
set_property PACKAGE_PIN W5 [get_ports CLK100MHZ]							
	set_property IOSTANDARD LVCMOS33 [get_ports CLK100MHZ]
# set_property IOSTANDARD LVCMOS33 [get_ports CLK100MHZ]
#    create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports CLK100MHZ]

	
#7 segment display
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

set_property PACKAGE_PIN V7 [get_ports seg[7]]							
	set_property IOSTANDARD LVCMOS33 [get_ports seg[7]]

set_property PACKAGE_PIN U2 [get_ports {an[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

set_property PACKAGE_PIN G2 [get_ports colorSensor_S3]
set_property IOSTANDARD LVCMOS33 [get_ports colorSensor_S3]
#Sch name = JA2
set_property PACKAGE_PIN G3 [get_ports colorSensor_S2]
set_property IOSTANDARD LVCMOS33 [get_ports colorSensor_S2]
#Sch name = JA3
set_property PACKAGE_PIN H1 [get_ports colorSensorPulse]
set_property IOSTANDARD LVCMOS33 [get_ports colorSensorPulse]

#Switches for speed change
set_property PACKAGE_PIN V17 [get_ports {speedChange[1]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {speedChange[1]}]
set_property PACKAGE_PIN V16 [get_ports {speedChange[0]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {speedChange[0]}] 
#switchs for enables
set_property PACKAGE_PIN T1 [get_ports {enA}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enA}]
set_property PACKAGE_PIN R2 [get_ports {enB}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enB}]
 #switches for speed states
 set_property PACKAGE_PIN R3 [get_ports {sw0}]					
     set_property IOSTANDARD LVCMOS33 [get_ports {sw0}]
 set_property PACKAGE_PIN W2 [get_ports {sw1}]                    
     set_property IOSTANDARD LVCMOS33 [get_ports {sw1}]
 set_property PACKAGE_PIN U1 [get_ports {sw2}]                    
       set_property IOSTANDARD LVCMOS33 [get_ports {sw2}]
 set_property PACKAGE_PIN T2 [get_ports {sw3}]                    
             set_property IOSTANDARD LVCMOS33 [get_ports {sw3}]
             
#for IR
set_property PACKAGE_PIN A16 [get_ports {irPing_left}]
        set_property IOSTANDARD LVCMOS33 [get_ports {irPing_left}]
set_property PACKAGE_PIN A15 [get_ports {irPing_right}]
                set_property IOSTANDARD LVCMOS33 [get_ports {irPing_right}]
set_property PACKAGE_PIN A14 [get_ports {irPing_front}]
    set_property IOSTANDARD LVCMOS33 [get_ports {irPing_front}]

#motor ports
set_property PACKAGE_PIN L17 [get_ports {motorInput[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {motorInput[0]}]
set_property PACKAGE_PIN M19 [get_ports {motorInput[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {motorInput[1]}] 
set_property PACKAGE_PIN P17 [get_ports {motorInput[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {motorInput[2]}]
set_property PACKAGE_PIN M18 [get_ports {motorInput[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {motorInput[3]}]
    
### leds
set_property PACKAGE_PIN U3 [get_ports {led0}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led0}]
set_property PACKAGE_PIN P3 [get_ports {led1}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led1}]
set_property PACKAGE_PIN N3 [get_ports {led2}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led2}]
	
	
set_property PACKAGE_PIN W3 [get_ports {led3}]					
        set_property IOSTANDARD LVCMOS33 [get_ports {led3}]
   
   set_property PACKAGE_PIN V3 [get_ports {led4}]					
                set_property IOSTANDARD LVCMOS33 [get_ports {led4}]
   set_property PACKAGE_PIN N1 [get_ports {magnetON}]		
                    set_property IOSTANDARD LVCMOS33 [get_ports {magnetON}]
                     
set_property PACKAGE_PIN H2 [get_ports {irFlag_front[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {irFlag_front[1]}]
set_property PACKAGE_PIN J1 [get_ports {inputSignal}]
    set_property IOSTANDARD LVCMOS33 [get_ports {inputSignal}] 
       
        
set_property PACKAGE_PIN B15 [get_ports {enableA_motor}]					
         set_property IOSTANDARD LVCMOS33 [get_ports {enableA_motor}]
     set_property PACKAGE_PIN P18 [get_ports {enableB_motor}]                    
         set_property IOSTANDARD LVCMOS33 [get_ports {enableB_motor}]
     
##Buttons     
set_property PACKAGE_PIN U18 [get_ports reset]						
	set_property IOSTANDARD LVCMOS33 [get_ports reset]

#Metal detector
set_property PACKAGE_PIN L2 [get_ports {irFlag_left[0]}]				
     set_property IOSTANDARD LVCMOS33 [get_ports {irFlag_left[0]}]

##Pmod Header JB
##Sch name = JB1
#set_property PACKAGE_PIN A14 [get_ports {irOUT_left}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {irOUT_left}]
##Sch name = JB2
#set_property PACKAGE_PIN A16 [get_ports {irOUT_right}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {irOUT_right}]
##Sch name = JB3
#set_property PACKAGE_PIN B15 [get_ports {irOUT_front}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {irOUT_front}]
#Sch name = JB4
set_property PACKAGE_PIN K2 [get_ports {metalVal}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {metalVal}]
#Sch name = JB7
set_property PACKAGE_PIN J2 [get_ports {irFlag_right[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {irFlag_right[0]}]
#Sch name = JB8
set_property PACKAGE_PIN A17 [get_ports {irFlag_left[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {irFlag_left[1]}]
#Sch name = JB9
set_property PACKAGE_PIN C15 [get_ports {irFlag_right[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {irFlag_right[1]}]
#Sch name = JB10 
set_property PACKAGE_PIN C16 [get_ports {irFlag_front[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {irFlag_front[0]}]
 
set_property PACKAGE_PIN P1 [get_ports {T1_led}]					
        set_property IOSTANDARD LVCMOS33 [get_ports {T1_led}]
set_property PACKAGE_PIN L1 [get_ports {R2_led}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {R2_led}]
        
	
