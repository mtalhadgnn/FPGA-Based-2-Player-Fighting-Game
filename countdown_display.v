module countdown_display(
    input [9:0] x,
    input [9:0] y,
    input [1:0] countdown_value,
    output reg [7:0] color_out,
    input in_digit_area
);
	// 3 2 1 
    reg [7:0] digit_3 [0:7];
    reg [7:0] digit_2 [0:7];
    reg [7:0] digit_1 [0:7];
	
	// GOOOOO(GO)
	 reg [7:0] letter_G [0:7];
    reg [7:0] letter_O [0:7];

    
    initial begin
        //digit 3
        digit_3[0] = 8'b11111110;
        digit_3[1] = 8'b00000110;
        digit_3[2] = 8'b00001100;
        digit_3[3] = 8'b11111110;
        digit_3[4] = 8'b00000110;
        digit_3[5] = 8'b00000110;
        digit_3[6] = 8'b11111110;
        digit_3[7] = 8'b00000000;
        
        //digit 2
        digit_2[0] = 8'b11111110;
        digit_2[1] = 8'b00000110;
        digit_2[2] = 8'b00000110;
        digit_2[3] = 8'b11111110;
        digit_2[4] = 8'b11000000;
        digit_2[5] = 8'b11000000;
        digit_2[6] = 8'b11111110;
        digit_2[7] = 8'b00000000;
        
        //digit 1
        digit_1[0] = 8'b00110000;
        digit_1[1] = 8'b01110000;
        digit_1[2] = 8'b00110000;
        digit_1[3] = 8'b00110000;
        digit_1[4] = 8'b00110000;
        digit_1[5] = 8'b00110000;
        digit_1[6] = 8'b11111100;
        digit_1[7] = 8'b00000000;
		  
		  //letter G
		  letter_G[0] = 8'b01111110;
        letter_G[1] = 8'b11000000;
        letter_G[2] = 8'b11000000;
        letter_G[3] = 8'b11001110;
        letter_G[4] = 8'b11000110;
        letter_G[5] = 8'b11000110;
        letter_G[6] = 8'b01111110;
        letter_G[7] = 8'b00000000;
        
        //letter O
        letter_O[0] = 8'b01111100;
        letter_O[1] = 8'b11000110;
        letter_O[2] = 8'b11000110;
        letter_O[3] = 8'b11000110;
        letter_O[4] = 8'b11000110;
        letter_O[5] = 8'b11000110;
        letter_O[6] = 8'b01111100;
        letter_O[7] = 8'b00000000;
    end

    
    wire [2:0] digit_x = (x - 316); 
    wire [2:0] digit_y = (y - 216); 
    wire in_digit_char = (x >= 316 && x < 324 && y >= 216 && y < 224);
    
	 
	 wire [2:0] go_x = (x >= 308 && x < 316) ? (x - 308) : (x - 324); // G: 308-316, O: 324-332
    wire [2:0] go_y = (y - 216);
    wire in_G = (x >= 308 && x < 316 && y >= 216 && y < 224);
    wire in_O = (x >= 324 && x < 332 && y >= 216 && y < 224);
    wire in_go_area = in_G || in_O;
    reg pixel_on;
	 
    always @(*) begin
        pixel_on = 0;
        
        case (countdown_value)
            2'b11: begin //3
                if (in_digit_char) begin
                    pixel_on = digit_3[digit_y][digit_x];
                end
            end
            2'b10: begin //2
                if (in_digit_char) begin
                    pixel_on = digit_2[digit_y][digit_x];
                end
            end
            2'b01: begin //1
                if (in_digit_char) begin
                    pixel_on = digit_1[digit_y][digit_x];
                end
            end
            2'b00: begin //GO
                if (in_G) begin
                    pixel_on = letter_G[go_y][go_x];
                end else if (in_O) begin
                    pixel_on = letter_O[go_y][go_x];
                end
            end
        endcase
    end

    always @(*) begin
        if (in_digit_area) begin
            case (countdown_value)
                2'b11: color_out = pixel_on ? 8'b00000000 : 8'b11111111; 
                2'b10: color_out = pixel_on ? 8'b11111111 : 8'b11100000; 
                2'b01: color_out = pixel_on ? 8'b11111111 : 8'b00011100; 
                2'b00: color_out = pixel_on ? 8'b11111111 : 8'b00000011;
					 default: color_out = 8'b00000000;
            endcase
        end else begin
            color_out = 8'b00000000;
        end
    end
endmodule