module character_render (
    input wire clk,
    input wire [9:0] vga_x,
    input wire [9:0] vga_y,
    input wire [9:0] sprite_x,
    input wire [9:0] sprite_y,
    input wire [3:0] sprite_select,
    output reg [7:0] pixel_data,
    output reg pixel_on
);
    parameter SPRITE_WIDTH = 32;
    parameter SPRITE_HEIGHT = 120;
    
    reg [12:0] rom_addr;
    reg [7:0] rom_data;
    
    // ROM'lar - eksik olan idle ve attack ROM'ları eklendi
    reg [7:0] ryu_idle_rom [0:(SPRITE_WIDTH*SPRITE_HEIGHT)-1];
    reg [7:0] ryu_attack_rom [0:(SPRITE_WIDTH*SPRITE_HEIGHT)-1];
    reg [7:0] ryu_block_rom [0:(SPRITE_WIDTH*SPRITE_HEIGHT)-1];
    reg [7:0] ryu_dir_attack_rom [0:(SPRITE_WIDTH*SPRITE_HEIGHT)-1];
    reg [7:0] ryu_stun_rom [0:(SPRITE_WIDTH*SPRITE_HEIGHT)-1];
    reg [7:0] ryu_lose_rom [0:(SPRITE_WIDTH*SPRITE_HEIGHT)-1];
    reg [7:0] ken_idle_rom [0:(SPRITE_WIDTH*SPRITE_HEIGHT)-1];
    reg [7:0] ken_attack_rom [0:(SPRITE_WIDTH*SPRITE_HEIGHT)-1];
    reg [7:0] ken_block_rom [0:(SPRITE_WIDTH*SPRITE_HEIGHT)-1];
    reg [7:0] ken_dir_attack_rom [0:(SPRITE_WIDTH*SPRITE_HEIGHT)-1];
    reg [7:0] ken_stun_rom [0:(SPRITE_WIDTH*SPRITE_HEIGHT)-1];
    reg [7:0] ken_lose_rom [0:(SPRITE_WIDTH*SPRITE_HEIGHT)-1];
    
    initial begin
        $readmemh("ryu_idle.hex", ryu_idle_rom);
        $readmemh("ryu_attack.hex", ryu_attack_rom);
        $readmemh("ryu_block.hex", ryu_block_rom);
        $readmemh("ryu_dir_attack.hex", ryu_dir_attack_rom);
        $readmemh("ryu_stun.hex", ryu_stun_rom);
        $readmemh("ryu_lose.hex", ryu_lose_rom);
        $readmemh("ken_idle.hex", ken_idle_rom);
        $readmemh("ken_attack.hex", ken_attack_rom);
        $readmemh("ken_block.hex", ken_block_rom);
        $readmemh("ken_dir_attack.hex", ken_dir_attack_rom);
        $readmemh("ken_stun.hex", ken_stun_rom);
        $readmemh("ken_lose.hex", ken_lose_rom);
    end
    
    // Sprite sınırları kontrolü - ölçekleme geri eklendi
    wire [10:0] scaled_x = (vga_x - sprite_x) >> 1;
    wire [10:0] scaled_y = (vga_y - sprite_y) >> 1;
    wire inside_sprite = (scaled_x < SPRITE_WIDTH) && (scaled_y < SPRITE_HEIGHT);
    
    always @(posedge clk) begin
        if (inside_sprite) begin
            rom_addr <= scaled_y * SPRITE_WIDTH + scaled_x;
            
            case (sprite_select)
                // Player 1 (Ryu) sprites
                4'b0000: rom_data <= ryu_idle_rom[rom_addr];        // IDLE
                4'b0001: rom_data <= ryu_attack_rom[rom_addr];      // ATTACK (neutral)
                4'b0010: rom_data <= ryu_block_rom[rom_addr];       // BLOCK/BLOCKSTUN
                4'b0011: rom_data <= ryu_dir_attack_rom[rom_addr];  // DIRECTIONAL ATTACK
                4'b0100: rom_data <= ryu_stun_rom[rom_addr];        // HITSTUN
                4'b0101: rom_data <= ryu_lose_rom[rom_addr];        // LOSE
                4'b0110: rom_data <= ryu_idle_rom[rom_addr];        // MOVING (idle sprite kullan)
                4'b0111: rom_data <= ryu_attack_rom[rom_addr];      // ATTACK_STARTUP/ACTIVE/RECOVER
                
                // Player 2 (Ken) sprites
                4'b1000: rom_data <= ken_idle_rom[rom_addr];        // IDLE
                4'b1001: rom_data <= ken_attack_rom[rom_addr];      // ATTACK (neutral)
                4'b1010: rom_data <= ken_block_rom[rom_addr];       // BLOCK/BLOCKSTUN
                4'b1011: rom_data <= ken_dir_attack_rom[rom_addr];  // DIRECTIONAL ATTACK
                4'b1100: rom_data <= ken_stun_rom[rom_addr];        // HITSTUN
                4'b1101: rom_data <= ken_lose_rom[rom_addr];        // LOSE
                4'b1110: rom_data <= ken_idle_rom[rom_addr];        // MOVING (idle sprite kullan)
                4'b1111: rom_data <= ken_attack_rom[rom_addr];      // ATTACK_STARTUP/ACTIVE/RECOVER
                
                default: rom_data <= 8'hFF; // Transparent
            endcase
            
            pixel_data <= rom_data;
            pixel_on <= (rom_data != 8'hFF); // FF = transparent pixel
        end else begin
            pixel_data <= 8'b00000000; // Siyah
            pixel_on <= 1'b0;
        end
    end
endmodule