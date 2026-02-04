module hit_detection(
    input clk,
    input reset,
    input [9:0] p1_x,
    input [3:0] p1_state,
    input [1:0] p1_health,
    input [9:0] p2_x,
    input [3:0] p2_state,
    input [1:0] p2_health,
    input timer_limit_reached,
    output reg p1_hit_by_p2,
    output reg p2_hit_by_p1,
    output reg game_over,
    output reg p1_wins,
    output reg p2_wins
);

    parameter CHAR_WIDTH = 64;
    parameter CHAR_HEIGHT = 120;
    parameter CHAR_Y = 280;
    
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
    
	 //hitboxes
    // P1
    wire p1_has_normal_hitbox = (p1_state == ATTACK_ACTIVE);
    wire p1_has_dir_hitbox = (p1_state == DIR_ATTACK_ACTIVE);
    
    // P1 normal attack hitbox
    wire [9:0] p1_normal_hitbox_left = p1_x + CHAR_WIDTH*2/3;
    wire [9:0] p1_normal_hitbox_right = p1_x + CHAR_WIDTH + 20;
    wire [9:0] p1_normal_hitbox_top = CHAR_Y + 24;
    wire [9:0] p1_normal_hitbox_bottom = CHAR_Y + 60;
    
    // P1 dir attack hitbox
    wire [9:0] p1_dir_hitbox_left = p1_x + CHAR_WIDTH/2;
    wire [9:0] p1_dir_hitbox_right = p1_x + CHAR_WIDTH + 25;
    wire [9:0] p1_dir_hitbox_top = CHAR_Y + 20;
    wire [9:0] p1_dir_hitbox_bottom = CHAR_Y + 70;
    
    // P2
    wire p2_has_normal_hitbox = (p2_state == ATTACK_ACTIVE);
    wire p2_has_dir_hitbox = (p2_state == DIR_ATTACK_ACTIVE);
    
    // P2 normal attack hitbox
    wire [9:0] p2_normal_hitbox_left = p2_x - 10;
    wire [9:0] p2_normal_hitbox_right = p2_x + CHAR_WIDTH*2/3;
    wire [9:0] p2_normal_hitbox_top = CHAR_Y + 24;
    wire [9:0] p2_normal_hitbox_bottom = CHAR_Y + 60;
    
    // P2 directional attack hitbox
    wire [9:0] p2_dir_hitbox_left = p2_x - 5;
    wire [9:0] p2_dir_hitbox_right = p2_x + CHAR_WIDTH/2;
    wire [9:0] p2_dir_hitbox_top = CHAR_Y + 30;
    wire [9:0] p2_dir_hitbox_bottom = CHAR_Y + 70;
    
	 //Hurtboxes
	 //P1 
    wire [9:0] p1_hurtbox_left = p1_x + 8;
    wire [9:0] p1_hurtbox_right = p1_x + CHAR_WIDTH - 8;
    wire [9:0] p1_hurtbox_top = CHAR_Y + 4;
    wire [9:0] p1_hurtbox_bottom = CHAR_Y + CHAR_HEIGHT - 4;
    
    // P2
    wire [9:0] p2_hurtbox_left = p2_x + 8;
    wire [9:0] p2_hurtbox_right = p2_x + CHAR_WIDTH - 8;
    wire [9:0] p2_hurtbox_top = CHAR_Y + 4;
    wire [9:0] p2_hurtbox_bottom = CHAR_Y + CHAR_HEIGHT - 4;
    
    // calculating if hit is occured
    wire p1_normal_hits_p2 = p1_has_normal_hitbox && 
                            ((p1_normal_hitbox_left < p2_hurtbox_right) && 
                             (p1_normal_hitbox_right > p2_hurtbox_left) && 
                             (p1_normal_hitbox_top < p2_hurtbox_bottom) && 
                             (p1_normal_hitbox_bottom > p2_hurtbox_top));
                                        
    wire p1_dir_hits_p2 = p1_has_dir_hitbox && 
                         ((p1_dir_hitbox_left < p2_hurtbox_right) && 
                          (p1_dir_hitbox_right > p2_hurtbox_left) && 
                          (p1_dir_hitbox_top < p2_hurtbox_bottom) && 
                          (p1_dir_hitbox_bottom > p2_hurtbox_top));
                                     
    wire p2_normal_hits_p1 = p2_has_normal_hitbox && 
                            ((p2_normal_hitbox_left < p1_hurtbox_right) && 
                             (p2_normal_hitbox_right > p1_hurtbox_left) && 
                             (p2_normal_hitbox_top < p1_hurtbox_bottom) && 
                             (p2_normal_hitbox_bottom > p1_hurtbox_top));
                                        
    wire p2_dir_hits_p1 = p2_has_dir_hitbox && 
                         ((p2_dir_hitbox_left < p1_hurtbox_right) && 
                          (p2_dir_hitbox_right > p1_hurtbox_left) && 
                          (p2_dir_hitbox_top < p1_hurtbox_bottom) && 
                          (p2_dir_hitbox_bottom > p1_hurtbox_top));
    
    wire p1_hits_p2 = p1_normal_hits_p2 || p1_dir_hits_p2;
    wire p2_hits_p1 = p2_normal_hits_p1 || p2_dir_hits_p1;
    
    // cases where cannot get hit
    wire p2_can_be_hit = (p2_state != HITSTUN) && (p2_state != BLOCKSTUN) && (p2_state != LOSE);
    wire p1_can_be_hit = (p1_state != HITSTUN) && (p1_state != BLOCKSTUN) && (p1_state != LOSE);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            p1_hit_by_p2 <= 1'b0;
            p2_hit_by_p1 <= 1'b0;
        end else begin
            p1_hit_by_p2 <= p2_hits_p1 && p1_can_be_hit;
            p2_hit_by_p1 <= p1_hits_p2 && p2_can_be_hit;
        end
    end

    //general logic of hit detect
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            game_over <= 1'b0;
            p1_wins <= 1'b0;
            p2_wins <= 1'b0;
        end else begin
            // after99 sec draw
            if (timer_limit_reached) begin
                game_over <= 1'b1;
                p1_wins <= 1'b0;
                p2_wins <= 1'b0;
            end else if (p1_health == 0 && p2_health == 0) begin
                // die simul.
                game_over <= 1'b1;
                p1_wins <= 1'b0;
                p2_wins <= 1'b0;
            end else if (p1_health == 0) begin
                game_over <= 1'b1;
                p1_wins <= 1'b0;
                p2_wins <= 1'b1;
            end else if (p2_health == 0) begin
                game_over <= 1'b1;
                p1_wins <= 1'b1;
                p2_wins <= 1'b0;
            end else begin
                game_over <= 1'b0;
                p1_wins <= 1'b0;
                p2_wins <= 1'b0;
            end
        end
    end

endmodule