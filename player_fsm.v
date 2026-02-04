module player_fsm(
    input reset,
    input sw1,
    input clk_60hz,
    input manual_step,
    input move_left,
    input move_right,
    input attack,
    input hit_by_opponent,
    input blocked_opponent,
    input [9:0] opponent_x, 
    output reg [1:0] health,
    output reg [1:0] block_points,
    output reg [9:0] player,
    output reg [3:0] state
);

    parameter IDLE               = 4'b0000;
    parameter MOVING_L           = 4'b0001;
    parameter MOVING_R           = 4'b0010;
    parameter ATTACK_STARTUP     = 4'b0011;
    parameter ATTACK_ACTIVE      = 4'b0100;
    parameter ATTACK_RECOVER     = 4'b0101;
    parameter DIR_ATTACK_STARTUP = 4'b0110;
    parameter DIR_ATTACK_ACTIVE  = 4'b0111;
    parameter DIR_ATTACK_RECOVER = 4'b1000;
    parameter HITSTUN            = 4'b1001;
    parameter BLOCKSTUN          = 4'b1010;
    parameter LOSE               = 4'b1011; 

    reg [3:0] current_state, next_state;
    reg [4:0] frame_counter;

    wire game_clk;
    assign game_clk = (sw1 == 1'b0) ? clk_60hz : manual_step;

    parameter STARTUP_FRAMES  = 4;
    parameter ACTIVE_FRAMES   = 1;
    parameter RECOVER_FRAMES  = 15;
    parameter DIR_STARTUP_FRAMES  = 3;
    parameter DIR_ACTIVE_FRAMES   = 2;
    parameter DIR_RECOVER_FRAMES  = 14;
    parameter HITSTUN_FRAMES     = 14;
    parameter BLOCKSTUN_FRAMES   = 12;

    parameter STEP_LEFT   = -2;
    parameter STEP_RIGHT  = 3;
    parameter LEFT_BOUND  = 0;
    parameter RIGHT_BOUND = 576;
    parameter CHAR_WIDTH  = 64; 

    
    wire is_blocking;
    assign is_blocking = move_left; 
    
    // collision parrt
    parameter HURTBOX_MARGIN = 8;
	wire would_collide_left = (player + STEP_LEFT + CHAR_WIDTH - HURTBOX_MARGIN > opponent_x + HURTBOX_MARGIN) && 
                         (player + STEP_LEFT + HURTBOX_MARGIN < opponent_x + CHAR_WIDTH - HURTBOX_MARGIN);
	wire would_collide_right = (player + STEP_RIGHT + CHAR_WIDTH - HURTBOX_MARGIN > opponent_x + HURTBOX_MARGIN) && 
                          (player + STEP_RIGHT + HURTBOX_MARGIN < opponent_x + CHAR_WIDTH - HURTBOX_MARGIN);
    
    // FSM 
    always @(posedge game_clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            player <= 100;
            frame_counter <= 0;
            health <= 2'd3;
            block_points <= 2'd3;
        end else begin
            current_state <= next_state;
            
            // block/got hit
            if (hit_by_opponent && current_state != HITSTUN && current_state != BLOCKSTUN && current_state != LOSE) begin
                if (is_blocking && block_points > 0) begin
                    block_points <= block_points - 1;
                end else begin
                    health <= health - 1;
                end
            end
            
            case (current_state)
                MOVING_L: if (player > LEFT_BOUND && !would_collide_left)
                              player <= player + STEP_LEFT;
                MOVING_R: if (player < RIGHT_BOUND && !would_collide_right)
                              player <= player + STEP_RIGHT;
            endcase

            if (current_state != next_state)
                frame_counter <= 0;
            else if (current_state == ATTACK_STARTUP ||
                     current_state == ATTACK_ACTIVE ||
                     current_state == ATTACK_RECOVER ||
                     current_state == DIR_ATTACK_STARTUP ||
                     current_state == DIR_ATTACK_ACTIVE ||
                     current_state == DIR_ATTACK_RECOVER||
                     current_state == HITSTUN ||
                     current_state == BLOCKSTUN)
                frame_counter <= frame_counter + 1;
            else
                frame_counter <= 0;
        end
    end

    // State 
    always @(*) begin
        next_state = current_state;
        
        if (health == 0) begin
            next_state = LOSE;
        end
		  
        else if (hit_by_opponent && current_state != HITSTUN && current_state != BLOCKSTUN && current_state != LOSE) begin
            if (is_blocking && block_points > 0) begin
                next_state = BLOCKSTUN;
            end else begin
                next_state = HITSTUN;
            end
        end
		  
        else begin    
            case (current_state)
                IDLE: begin
                    if (attack)          next_state = ATTACK_STARTUP;
                    else if (move_left)  next_state = MOVING_L;
                    else if (move_right) next_state = MOVING_R;
                end
                MOVING_L: begin 
                    if (attack)                    next_state = DIR_ATTACK_STARTUP;
                    else if (!move_left)           next_state = IDLE;     
                end
                MOVING_R: begin
                    if (attack)                    next_state = DIR_ATTACK_STARTUP;
                    else if (!move_right)          next_state = IDLE;    
                end
                
                ATTACK_STARTUP:
                    if (frame_counter >= STARTUP_FRAMES)
                        next_state = ATTACK_ACTIVE;
                ATTACK_ACTIVE:
                    if (frame_counter >= ACTIVE_FRAMES)
                        next_state = ATTACK_RECOVER;
                ATTACK_RECOVER:
                    if (frame_counter >= RECOVER_FRAMES)
                        next_state = IDLE;
                
                DIR_ATTACK_STARTUP:
                    if (frame_counter >= DIR_STARTUP_FRAMES)
                        next_state = DIR_ATTACK_ACTIVE;
                DIR_ATTACK_ACTIVE:
                    if (frame_counter >= DIR_ACTIVE_FRAMES)
                        next_state = DIR_ATTACK_RECOVER;
                DIR_ATTACK_RECOVER:
                    if (frame_counter >= DIR_RECOVER_FRAMES)
                        next_state = IDLE;
                              
                HITSTUN:
                    if (frame_counter >= HITSTUN_FRAMES)
                        next_state = IDLE;
                BLOCKSTUN:
                    if (frame_counter >= BLOCKSTUN_FRAMES)
                        next_state = IDLE;
                LOSE:
                    next_state = LOSE;
                
            endcase
        end
    end

    always @(posedge game_clk) begin
        state <= current_state;
    end

endmodule