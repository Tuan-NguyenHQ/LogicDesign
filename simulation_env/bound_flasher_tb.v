`timescale 1ns / 1ps

module bound_flasher_tb;

reg rst_n, clk, flick;
wire [15:0] leds;
localparam cycle = 1;

bound_flasher inst0(rst_n, clk, flick, leds);

task init;
begin
    clk <= 0;
    rst_n <= 1;
    flick <= 0;
end
endtask

task normal;
begin
    init;
    #(5*cycle) flick <= 1;
    #(2*cycle) flick <= 0;
    #(133*cycle) flick <= 1;
    #(2*cycle) flick <= 0;
    #(125*cycle);
end
endtask 

task test_reset;
begin
    init;
    flick <= 1;
    rst_n <= 0;
    #(2*cycle) rst_n <= 1;
    #(50*cycle) rst_n <= 0;
    #(200*cycle);
end
endtask

task reset_on_each_state;
begin 
    init;
    #(5*cycle) flick <= 1;
    #(6*cycle) rst_n <= 0;
    #(4*cycle) rst_n <= 1; #(2*cycle) flick <= 0;
    #(20*cycle) rst_n <= 0;
    #(4*cycle) rst_n <= 1; flick <= 1; 
    #(2*cycle) flick <= 0;
    #(40*cycle) rst_n <= 0;
    #(4*cycle) rst_n <= 1; flick <= 1;
    #(2*cycle) flick <= 0;
    #(54*cycle) rst_n <= 0;
    #(4*cycle) rst_n <= 1; flick <= 1;
    #(2*cycle) flick <= 0;
    #(74*cycle) rst_n <= 0;
    #(4*cycle) rst_n <= 1; flick <= 1;
    #(2*cycle) flick <= 0;
    #(88*cycle) rst_n <= 0;
    #(4*cycle) rst_n <= 1; flick <= 1;
    #(2*cycle) flick <= 0;
    #(113*cycle) rst_n <= 0;
    #(100*cycle);
end 
endtask 

task always_flick;
begin
        init;
        flick <= 1;
        #(200*cycle);
end
endtask

task none_flick;
begin
        init;
        #(200*cycle);
end
endtask

task flick_on_0_10_at_led5;
begin
    init;
    #(5*cycle) flick <= 1;
    #(2*cycle) flick <= 0;
    #(33*cycle) flick <= 1;
    #(4*cycle) flick <= 0;
    #(200*cycle);
end
endtask

task flick_on_0_10_at_led10;
begin 
    init;
    #(5*cycle) flick <= 1;
    #(2*cycle) flick <= 0;
    #(43*cycle) flick <= 1;
    #(4*cycle) flick <= 0;
    #(200*cycle);
end 
endtask 

task flick_on_5_15_at_led5;
begin 
    init;
    #(4*cycle) flick <= 1;
    #(2*cycle) flick <= 0;
    #(57*cycle) flick <= 1;
    #(1*cycle) flick <= 0;
    #(200*cycle);
end 
endtask 

task flick_on_5_15_at_led10;
begin 
    init;
    #(4*cycle) flick <= 1;
    #(2*cycle) flick <= 0;
    #(66*cycle) flick <= 1;
    #(4*cycle) flick <= 0;
    #(200*cycle);
end 
endtask 


task arbitary_test;
begin
    clk <= 0; 
    #cycle rst_n <= 1;
    #(2*cycle) flick <= 1;
    #(25*cycle) flick <= 0;
    #(5*cycle) rst_n <= 0;
    #(10*cycle) rst_n <= 1;
    #(30*cycle) flick <= 1;
    #(100*cycle);
end 
endtask

initial begin
    //    normal;
    //    test_reset;
    //    always_flick;
    //    none_flick;
    //    flick_on_5_15_at_led5;
    //    flick_on_5_15_at_led10;
    //    flick_on_0_10_at_led10;     
    //    flick_on_0_10_at_led5;   
    //    reset_on_each_state;
    arbitary_test;
        $finish;
end

always begin
        #cycle clk <= ~clk;
end
initial begin
  $recordfile ("waves");
  $recordvars ("depth=0", bound_flasher_tb);
end

endmodule
