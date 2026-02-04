module menu_background (
    input wire [9:0] x,
    input wire [9:0] y,
    output reg [7:0] color_out
);


    parameter IMAGE_WIDTH = 160;
    parameter IMAGE_HEIGHT = 120;
    parameter SCALE_FACTOR = 2; 
    parameter MEM_SIZE = IMAGE_WIDTH * IMAGE_HEIGHT;
    
    wire [7:0] x_sc;
    wire [6:0] y_sc;
    wire [14:0] memory_address;
    
    assign x_sc = x[9:SCALE_FACTOR];
    assign y_sc = y[8:SCALE_FACTOR];
    
    assign memory_address = (y_sc * IMAGE_WIDTH) + x_sc;
    
    reg [7:0] image_memory [0:MEM_SIZE-1];
    
    initial begin
      $readmemh("menu_arcade_bg.hex", image_memory);
	 end

    
    always @(*) begin
        if (memory_address < MEM_SIZE)
            color_out = image_memory[memory_address];
        else
            color_out = 8'h00;
    end

endmodule