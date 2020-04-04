module snake(
	input wire CLK_IN,		// input clock signal
	input wire RST_N,		// user button...
	output wire [0:7] R,		// RGB...
	output wire [0:7] G,
	output wire [0:7] B,
	output wire LCD_CLK,		// lcd click
	output wire LCD_HSYNC,	// lcd horizontal sync signal
	output wire LCD_VSYNC,	// lcd vertical sync signal
	output wire LCD_DEN,		// lcd data enable
	output wire LCD_PWM		// backlight
    );
    
    	localparam H_LINE = 480; 					// horizontal resolution in pixels
    	localparam H_FRONT_PORCH = 5; 				// horizontal front porch
	localparam H_SYNC_WIDTH = 1; 					// horizontal sync width
	localparam H_BACK_PORCH = 40;					// horizontal back porch
	localparam V_LINE = 272;						// vertical resolution in pixels
	localparam V_FRONT_PORCH = 8; 				// vertical front porch
	localparam V_SYNC_WIDTH = 1; 					// vertical sync Width
	localparam V_BACK_PORCH = 8;					// vertical back porch
    
    	wire clk_lcd;
	wire clklock;
	wire lcd_data_en;
	wire [10:0] hsync;
	wire [10:0] vsync;
	
	wire [7:0] pixel_data;
	wire [16:0] addra;
    
    	pll timings
	(
		.refclk		(CLK_IN),
		.reset		(~RST_N),
		.extlock		(clklock),
		.clk0_out	(clk_lcd)
	); 
	
	wire [10:0] x_coord;
	wire [10:0] y_coord;
	
	lcd_sync 
	#(
		.H_LINE(H_LINE),
		.H_FRONT_PORCH(H_FRONT_PORCH),
		.H_SYNC_WIDTH(H_SYNC_WIDTH),
		.H_BACK_PORCH(H_BACK_PORCH),
		.V_LINE(V_LINE),
		.V_FRONT_PORCH(V_FRONT_PORCH),
		.V_SYNC_WIDTH(V_SYNC_WIDTH),
		.V_BACK_PORCH(V_BACK_PORCH)
	)
	FT043T4802724 // this is my lcd model :)
	(
  		.clk			(clk_lcd),
  		.rest_n		(RST_N),
		.lcd_clk		(LCD_CLK),
		.lcd_pwm		(LCD_PWM),
  		.lcd_hsync	(LCD_HSYNC), 
  		.lcd_vsync	(LCD_VSYNC), 
  		.lcd_de		(LCD_DEN),
  		.o_x			(x_coord),
  		.o_y			(y_coord),
		.addr		(addra)
  	);
 
  	mem batman
	(
		.doa (pixel_data),
		.addra (addra), 
		.clka (LCD_CLK), 
		.rsta (~RST_N)
		
	);
    
    data_out data_out
    (
		.clk_lcd		(LCD_CLK), 
		.R			(R),
		.G			(G),
		.B			(B),
		.den			(LCD_DEN),
		.pixel		(pixel_data)

    );
    
endmodule