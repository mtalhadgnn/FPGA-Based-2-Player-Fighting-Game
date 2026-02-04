module health_block_bars(
    input clk,
    input [9:0] vga_x,
    input [9:0] vga_y,
    input [1:0] p1_health,      
    input [1:0] p1_block_points, 
    input [1:0] p2_health,      
    input [1:0] p2_block_points, 
    output reg [7:0] bar_color,
    output reg bar_active
);

    parameter BAR_WIDTH = 20;
    parameter BAR_HEIGHT = 8;
    parameter BAR_SPACING = 4;
    
    parameter P1_HEALTH_X = 20;
    parameter P1_HEALTH_Y = 20;
    parameter P1_BLOCK_X = 20;
    parameter P1_BLOCK_Y = 35;
    
    parameter P2_HEALTH_X = 580;  
    parameter P2_HEALTH_Y = 20;
    parameter P2_BLOCK_X = 580;
    parameter P2_BLOCK_Y = 35;
    
    reg [7:0] health_bar_full [0:159];  
    reg [7:0] health_bar_empty [0:159];
    
    reg [7:0] block_bar_full [0:159];   
    reg [7:0] block_bar_empty [0:159];
    
    
    initial begin
        $readmemh("health_bar_full.hex", health_bar_full);
        $readmemh("health_bar_empty.hex", health_bar_empty);
        $readmemh("block_bar_full.hex", block_bar_full);
        $readmemh("block_bar_empty.hex", block_bar_empty);
    end
    
    wire in_p1_health1, in_p1_health2, in_p1_health3;
    wire in_p1_block1, in_p1_block2, in_p1_block3;
    wire in_p2_health1, in_p2_health2, in_p2_health3;
    wire in_p2_block1, in_p2_block2, in_p2_block3;
    
    // P1 healt
    assign in_p1_health1 = (vga_x >= P1_HEALTH_X && vga_x < P1_HEALTH_X + BAR_WIDTH &&
                           vga_y >= P1_HEALTH_Y && vga_y < P1_HEALTH_Y + BAR_HEIGHT);
    assign in_p1_health2 = (vga_x >= P1_HEALTH_X + (BAR_WIDTH + BAR_SPACING) && vga_x < P1_HEALTH_X + (BAR_WIDTH + BAR_SPACING) + BAR_WIDTH &&
                           vga_y >= P1_HEALTH_Y && vga_y < P1_HEALTH_Y + BAR_HEIGHT);
    assign in_p1_health3 = (vga_x >= P1_HEALTH_X + (BAR_WIDTH + BAR_SPACING) * 2 && vga_x < P1_HEALTH_X + (BAR_WIDTH + BAR_SPACING) * 2 + BAR_WIDTH &&
                           vga_y >= P1_HEALTH_Y && vga_y < P1_HEALTH_Y + BAR_HEIGHT);
    
    // P1 block
    assign in_p1_block1 = (vga_x >= P1_BLOCK_X && vga_x < P1_BLOCK_X + BAR_WIDTH &&
                          vga_y >= P1_BLOCK_Y && vga_y < P1_BLOCK_Y + BAR_HEIGHT);
    assign in_p1_block2 = (vga_x >= P1_BLOCK_X + (BAR_WIDTH + BAR_SPACING) && vga_x < P1_BLOCK_X + (BAR_WIDTH + BAR_SPACING) + BAR_WIDTH &&
                          vga_y >= P1_BLOCK_Y && vga_y < P1_BLOCK_Y + BAR_HEIGHT);
    assign in_p1_block3 = (vga_x >= P1_BLOCK_X + (BAR_WIDTH + BAR_SPACING) * 2 && vga_x < P1_BLOCK_X + (BAR_WIDTH + BAR_SPACING) * 2 + BAR_WIDTH &&
                          vga_y >= P1_BLOCK_Y && vga_y < P1_BLOCK_Y + BAR_HEIGHT);
    
    // P2 health
    assign in_p2_health1 = (vga_x >= P2_HEALTH_X - (BAR_WIDTH + BAR_SPACING) * 2 - BAR_WIDTH && vga_x < P2_HEALTH_X - (BAR_WIDTH + BAR_SPACING) * 2 &&
                           vga_y >= P2_HEALTH_Y && vga_y < P2_HEALTH_Y + BAR_HEIGHT);
    assign in_p2_health2 = (vga_x >= P2_HEALTH_X - (BAR_WIDTH + BAR_SPACING) - BAR_WIDTH && vga_x < P2_HEALTH_X - (BAR_WIDTH + BAR_SPACING) &&
                           vga_y >= P2_HEALTH_Y && vga_y < P2_HEALTH_Y + BAR_HEIGHT);
    assign in_p2_health3 = (vga_x >= P2_HEALTH_X - BAR_WIDTH && vga_x < P2_HEALTH_X &&
                           vga_y >= P2_HEALTH_Y && vga_y < P2_HEALTH_Y + BAR_HEIGHT);
    
    // P2 bllock
    assign in_p2_block1 = (vga_x >= P2_BLOCK_X - (BAR_WIDTH + BAR_SPACING) * 2 - BAR_WIDTH && vga_x < P2_BLOCK_X - (BAR_WIDTH + BAR_SPACING) * 2 &&
                          vga_y >= P2_BLOCK_Y && vga_y < P2_BLOCK_Y + BAR_HEIGHT);
    assign in_p2_block2 = (vga_x >= P2_BLOCK_X - (BAR_WIDTH + BAR_SPACING) - BAR_WIDTH && vga_x < P2_BLOCK_X - (BAR_WIDTH + BAR_SPACING) &&
                          vga_y >= P2_BLOCK_Y && vga_y < P2_BLOCK_Y + BAR_HEIGHT);
    assign in_p2_block3 = (vga_x >= P2_BLOCK_X - BAR_WIDTH && vga_x < P2_BLOCK_X &&
                          vga_y >= P2_BLOCK_Y && vga_y < P2_BLOCK_Y + BAR_HEIGHT);
    
    wire [7:0] mem_addr;
    reg [7:0] local_x, local_y;
    assign mem_addr = local_y * BAR_WIDTH + local_x;
    
    // Main logic
    always @(*) begin
        bar_active = 1'b0;
        bar_color = 8'b00000000;
        local_x = 0;
        local_y = 0;
        
        if (in_p1_health1) begin
            bar_active = 1'b1;
            local_x = vga_x - P1_HEALTH_X;
            local_y = vga_y - P1_HEALTH_Y;
            if (p1_health >= 1)
                bar_color = health_bar_full[mem_addr];
            else
                bar_color = health_bar_empty[mem_addr];
        end
        else if (in_p1_health2) begin
            bar_active = 1'b1;
            local_x = vga_x - (P1_HEALTH_X + (BAR_WIDTH + BAR_SPACING));
            local_y = vga_y - P1_HEALTH_Y;
            if (p1_health >= 2)
                bar_color = health_bar_full[mem_addr];
            else
                bar_color = health_bar_empty[mem_addr];
        end
        else if (in_p1_health3) begin
            bar_active = 1'b1;
            local_x = vga_x - (P1_HEALTH_X + (BAR_WIDTH + BAR_SPACING) * 2);
            local_y = vga_y - P1_HEALTH_Y;
            if (p1_health >= 3)
                bar_color = health_bar_full[mem_addr];
            else
                bar_color = health_bar_empty[mem_addr];
        end
        
        else if (in_p1_block1) begin
            bar_active = 1'b1;
            local_x = vga_x - P1_BLOCK_X;
            local_y = vga_y - P1_BLOCK_Y;
            if (p1_block_points >= 1)
                bar_color = block_bar_full[mem_addr];
            else
                bar_color = block_bar_empty[mem_addr];
        end
        else if (in_p1_block2) begin
            bar_active = 1'b1;
            local_x = vga_x - (P1_BLOCK_X + (BAR_WIDTH + BAR_SPACING));
            local_y = vga_y - P1_BLOCK_Y;
            if (p1_block_points >= 2)
                bar_color = block_bar_full[mem_addr];
            else
                bar_color = block_bar_empty[mem_addr];
        end
        else if (in_p1_block3) begin
            bar_active = 1'b1;
            local_x = vga_x - (P1_BLOCK_X + (BAR_WIDTH + BAR_SPACING) * 2);
            local_y = vga_y - P1_BLOCK_Y;
            if (p1_block_points >= 3)
                bar_color = block_bar_full[mem_addr];
            else
                bar_color = block_bar_empty[mem_addr];
        end
        
        else if (in_p2_health1) begin
            bar_active = 1'b1;
            local_x = vga_x - (P2_HEALTH_X - (BAR_WIDTH + BAR_SPACING) * 2 - BAR_WIDTH);
            local_y = vga_y - P2_HEALTH_Y;
            if (p2_health >= 1)
                bar_color = health_bar_full[mem_addr];
            else
                bar_color = health_bar_empty[mem_addr];
        end
        else if (in_p2_health2) begin
            bar_active = 1'b1;
            local_x = vga_x - (P2_HEALTH_X - (BAR_WIDTH + BAR_SPACING) - BAR_WIDTH);
            local_y = vga_y - P2_HEALTH_Y;
            if (p2_health >= 2)
                bar_color = health_bar_full[mem_addr];
            else
                bar_color = health_bar_empty[mem_addr];
        end
        else if (in_p2_health3) begin
            bar_active = 1'b1;
            local_x = vga_x - (P2_HEALTH_X - BAR_WIDTH);
            local_y = vga_y - P2_HEALTH_Y;
            if (p2_health >= 3)
                bar_color = health_bar_full[mem_addr];
            else
                bar_color = health_bar_empty[mem_addr];
        end
        
        else if (in_p2_block1) begin
            bar_active = 1'b1;
            local_x = vga_x - (P2_BLOCK_X - (BAR_WIDTH + BAR_SPACING) * 2 - BAR_WIDTH);
            local_y = vga_y - P2_BLOCK_Y;
            if (p2_block_points >= 1)
                bar_color = block_bar_full[mem_addr];
            else
                bar_color = block_bar_empty[mem_addr];
        end
        else if (in_p2_block2) begin
            bar_active = 1'b1;
            local_x = vga_x - (P2_BLOCK_X - (BAR_WIDTH + BAR_SPACING) - BAR_WIDTH);
            local_y = vga_y - P2_BLOCK_Y;
            if (p2_block_points >= 2)
                bar_color = block_bar_full[mem_addr];
            else
                bar_color = block_bar_empty[mem_addr];
        end
        else if (in_p2_block3) begin
            bar_active = 1'b1;
            local_x = vga_x - (P2_BLOCK_X - BAR_WIDTH);
            local_y = vga_y - P2_BLOCK_Y;
            if (p2_block_points >= 3)
                bar_color = block_bar_full[mem_addr];
            else
                bar_color = block_bar_empty[mem_addr];
        end
    end

endmodule