`timescale 1ns/1ps

module bound_flasher(rst_n, clk, flick, leds);
    input rst_n, clk, flick;
    output reg [15:0]leds;
    
    parameter [2:0] INIT = 3'd0;
    parameter [2:0] TURN_ON_0_TO_5 = 3'd1;
    parameter [2:0] TURN_OFF_5_TO_0 = 3'd2;
    parameter [2:0] TURN_ON_0_TO_10 = 3'd3;
    parameter [2:0] TURN_OFF_10_TO_5 = 3'd4;
    parameter [2:0] TURN_ON_5_TO_15 = 3'd5;
    parameter [2:0] TURN_OFF_15_TO_0 = 3'd6;
    parameter [2:0] BLINK = 3'd7;
    reg [2:0] state = INIT;
    
    reg [2:0] state_temp;
    reg [15:0] leds_temp;
    reg blink = 1'b0;
    
    initial begin
        leds = 16'h0;
        leds_temp = 16'h0;
        state = INIT;
//        leds = 16'h0; 
    end
    
    
    always @(flick, leds, posedge rst_n) begin 
        begin       
        case(state)
            INIT:
                begin
                    if(flick && rst_n) begin
                        leds_temp <= 16'h1;
                        state <= TURN_ON_0_TO_5;
                    end
                    // else state <= INIT;
                end
            TURN_ON_0_TO_5:
                begin
                    if(leds == 16'h3F) begin 
                        state <= TURN_OFF_5_TO_0;
                    end 
                end
            TURN_OFF_5_TO_0:
                begin
                    if(leds == 16'h0) begin 
                        state <= TURN_ON_0_TO_10;
                    end 
                end
            TURN_ON_0_TO_10:
                begin
                    if(flick && (leds == 16'h3F|| leds == 16'h7FF))
                        state <= TURN_OFF_5_TO_0;
                    else if(!flick && leds == 16'h7FF)
                        state <= TURN_OFF_10_TO_5;
                end
            TURN_OFF_10_TO_5:
                begin
                    if(leds == 16'h1F) begin 
                        state <= TURN_ON_5_TO_15;
                    end
                end
            TURN_ON_5_TO_15:
                begin
                    if(flick && (leds == 16'h3F || leds == 16'h7FF))
                        state <= TURN_OFF_10_TO_5;
                    else if(!flick && leds == 16'hFFFF)
                        state <= TURN_OFF_15_TO_0;
                end
            TURN_OFF_15_TO_0:
                begin
                    if(leds == 16'h0)
                        state <= BLINK;
                end
            BLINK:
                begin
                    if(leds == 16'hFFFF)
                        state <= INIT;
                end
            default:
                begin
                    state <= INIT;
                    leds <= 16'h0;
                end
        endcase
    end
    end
    
    always @(state, leds)  
    begin 
        if(state == TURN_ON_0_TO_5 || state == TURN_ON_0_TO_10 || state == TURN_ON_5_TO_15)
            begin 
            leds_temp <= (leds << 1) | 16'h1;
            end 
        else if(state == TURN_OFF_10_TO_5 || state == TURN_OFF_15_TO_0 || state == TURN_OFF_5_TO_0)
            begin 
            leds_temp <= (leds >> 1);
            end
        else if(state == INIT)
            begin 
            leds_temp <= 16'h0;
            end 
        else if(state == BLINK)
            begin 
            leds_temp <= 16'hFFFF;
            end 
     end 

    always @(posedge clk, negedge rst_n) begin 
        if(rst_n == 0) 
            begin 
            leds <= 16'h0;
            state <= INIT;
            end 
        else leds <= leds_temp;
    end 

    // always @(negedge rst_n) begin
    //     leds <= 16'h0;
    //     leds_temp <= 16'h0;
    //     state <= INIT;
    // end 

    // always @(posedge clk) begin
    //     leds <= leds _temp;
    // end
endmodule