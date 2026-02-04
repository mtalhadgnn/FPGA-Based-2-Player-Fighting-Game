module game_over_display(
    input [9:0] vga_x,
    input [9:0] vga_y,
    input p1_wins,
    input p2_wins,
    input [6:0] match_duration,
    output reg [7:0] game_over_color,
    output reg game_over_active
);
    parameter BG_COLOR = 8'b00100100;        
    parameter BORDER_COLOR = 8'b11111111;    
    parameter TEXT_COLOR = 8'b11111100;      
    
    // text
    parameter TEXT_X = 250;
    parameter TEXT_Y = 200;
    parameter CHAR_W = 30;
    parameter CHAR_H = 40;
    parameter BORDER_WIDTH = 8;
    
    wire [9:0] c1_x = TEXT_X;                    
    wire [9:0] c2_x = TEXT_X + CHAR_W;             
    wire [9:0] c3_x = TEXT_X + CHAR_W * 2;       
    wire [9:0] c4_x = TEXT_X + CHAR_W * 3;       
    wire [9:0] c5_x = TEXT_X + CHAR_W * 4;       
    
    wire [3:0] tens = (match_duration >= 10) ? match_duration / 10 : 4'd0;
    wire [3:0] ones = match_duration % 10;
    
    wire in_border = (vga_x < BORDER_WIDTH || vga_x >= 640-BORDER_WIDTH ||
                     vga_y < BORDER_WIDTH || vga_y >= 480-BORDER_WIDTH);
    
    //P
    wire p_block = (vga_x >= c1_x + 5 && vga_x < c1_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||  
                   (vga_x >= c1_x + 5 && vga_x < c1_x + 10 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||  
                   (vga_x >= c1_x + 20 && vga_x < c1_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 20) || 
                   (vga_x >= c1_x + 5 && vga_x < c1_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22);   
    
    //E  
    wire e_block = (vga_x >= c1_x + 5 && vga_x < c1_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||  
                   (vga_x >= c1_x + 5 && vga_x < c1_x + 10 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||  
                   (vga_x >= c1_x + 5 && vga_x < c1_x + 20 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22) || 
                   (vga_x >= c1_x + 5 && vga_x < c1_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);   
    
    //1
    wire n1_block = (vga_x >= c2_x + 12 && vga_x < c2_x + 17 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) || 
                    (vga_x >= c2_x + 5 && vga_x < c2_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);   
    
    //2
    wire n2_block = (vga_x >= c2_x + 5 && vga_x < c2_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||  
                    (vga_x >= c2_x + 20 && vga_x < c2_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 20) || 
                    (vga_x >= c2_x + 5 && vga_x < c2_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22) || 
                    (vga_x >= c2_x + 5 && vga_x < c2_x + 10 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 35) || 
                    (vga_x >= c2_x + 5 && vga_x < c2_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);   
    
    //q
    wire q_block = (vga_x >= c2_x + 5 && vga_x < c2_x + 25 && vga_y >= TEXT_Y + 12 && vga_y < TEXT_Y + 17) ||  
                   (vga_x >= c2_x + 5 && vga_x < c2_x + 10 && vga_y >= TEXT_Y + 12 && vga_y < TEXT_Y + 30) ||  
                   (vga_x >= c2_x + 20 && vga_x < c2_x + 25 && vga_y >= TEXT_Y + 12 && vga_y < TEXT_Y + 35) || 
                   (vga_x >= c2_x + 8 && vga_x < c2_x + 22 && vga_y >= TEXT_Y + 25 && vga_y < TEXT_Y + 30);    
    
    //-
    wire dash_block = (vga_x >= c3_x + 8 && vga_x < c3_x + 22 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22);
    
    // Digit patterns for tens place
    wire tens_0 = (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||   
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 10 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||   
                  (vga_x >= c4_x + 20 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||  
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);    
    
    wire tens_1 = (vga_x >= c4_x + 12 && vga_x < c4_x + 17 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||  
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);    
    
    wire tens_2 = (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||   
                  (vga_x >= c4_x + 20 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 20) ||  
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22) ||  
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 10 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 35) ||  
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);    
    
    wire tens_3 = (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||   
                  (vga_x >= c4_x + 20 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||  
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22) ||  
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);    
    
    wire tens_4 = (vga_x >= c4_x + 5 && vga_x < c4_x + 10 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 22) ||   
                  (vga_x >= c4_x + 20 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||  
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22);    
    
    wire tens_5 = (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||   
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 10 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 22) ||   
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22) ||  
                  (vga_x >= c4_x + 20 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 35) || 
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);    
    
    wire tens_6 = (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||   
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 10 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||   
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22) ||  
                  (vga_x >= c4_x + 20 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 35) || 
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);    
    
    wire tens_7 = (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||   
                  (vga_x >= c4_x + 20 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35);    
    
    wire tens_8 = (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||   
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 10 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||   
                  (vga_x >= c4_x + 20 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||  
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22) ||  
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);    
    
    wire tens_9 = (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||   
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 10 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 22) ||   
                  (vga_x >= c4_x + 20 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||  
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22) ||   
                  (vga_x >= c4_x + 5 && vga_x < c4_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);    
    
    // Select tens digit pattern
    wire tens_pattern = (tens == 4'd0) ? tens_0 :
                        (tens == 4'd1) ? tens_1 :
                        (tens == 4'd2) ? tens_2 :
                        (tens == 4'd3) ? tens_3 :
                        (tens == 4'd4) ? tens_4 :
                        (tens == 4'd5) ? tens_5 :
                        (tens == 4'd6) ? tens_6 :
                        (tens == 4'd7) ? tens_7 :
                        (tens == 4'd8) ? tens_8 :
                        (tens == 4'd9) ? tens_9 : 1'b0;
    
    // Digit patterns for ones place
    wire ones_0 = (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||   
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 10 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||   
                  (vga_x >= c5_x + 20 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||  
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);    
    
    wire ones_1 = (vga_x >= c5_x + 12 && vga_x < c5_x + 17 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||  
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);    
    
    wire ones_2 = (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||   
                  (vga_x >= c5_x + 20 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 20) ||  
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22) ||  
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 10 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 35) ||  
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);    
    
    wire ones_3 = (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||   
                  (vga_x >= c5_x + 20 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||  
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22) ||  
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);    
    
    wire ones_4 = (vga_x >= c5_x + 5 && vga_x < c5_x + 10 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 22) ||   
                  (vga_x >= c5_x + 20 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||  
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22);    
    
    wire ones_5 = (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||   
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 10 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 22) ||   
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22) ||  
                  (vga_x >= c5_x + 20 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 35) || 
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);    
    
    wire ones_6 = (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||   
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 10 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||   
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22) ||  
                  (vga_x >= c5_x + 20 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 35) || 
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);    
    
    wire ones_7 = (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||   
                  (vga_x >= c5_x + 20 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35);    
    
    wire ones_8 = (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||   
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 10 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||   
                  (vga_x >= c5_x + 20 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||  
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22) ||  
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);    
    
    wire ones_9 = (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 10) ||   
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 10 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 22) ||   
                  (vga_x >= c5_x + 20 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 5 && vga_y < TEXT_Y + 35) ||  
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 18 && vga_y < TEXT_Y + 22) ||  
                  (vga_x >= c5_x + 5 && vga_x < c5_x + 25 && vga_y >= TEXT_Y + 30 && vga_y < TEXT_Y + 35);    
    
    wire ones_pattern = (ones == 4'd0) ? ones_0 :
                        (ones == 4'd1) ? ones_1 :
                        (ones == 4'd2) ? ones_2 :
                        (ones == 4'd3) ? ones_3 :
                        (ones == 4'd4) ? ones_4 :
                        (ones == 4'd5) ? ones_5 :
                        (ones == 4'd6) ? ones_6 :
                        (ones == 4'd7) ? ones_7 :
                        (ones == 4'd8) ? ones_8 :
                        (ones == 4'd9) ? ones_9 : 1'b0;
    
    // which characters 
    wire first_char = (p1_wins || p2_wins) ? p_block : e_block;  // P or E
    wire second_char = p1_wins ? n1_block : 
                       p2_wins ? n2_block : q_block;             // 1, 2, or q
    
    // main display logic
    always @(*) begin
        game_over_active = 1'b1;
        
        if (in_border) begin
            game_over_color = BORDER_COLOR;
        end
        else if (first_char || second_char || dash_block || tens_pattern || ones_pattern) begin
            game_over_color = TEXT_COLOR;
        end
        else begin
            game_over_color = BG_COLOR;
        end
    end
endmodule