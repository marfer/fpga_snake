module lcd_sync
	#(
		parameter H_LINE = 0,
		parameter H_FRONT_PORCH = 0,
		parameter H_SYNC_WIDTH = 0,
		parameter H_BACK_PORCH = 0,
		parameter V_LINE = 0,
		parameter V_FRONT_PORCH = 0,
		parameter V_SYNC_WIDTH   = 0,
		parameter V_BACK_PORCH = 0 
	)
	(
		input wire clk,
		input wire rest_n,
		output wire lcd_clk,
		output wire lcd_pwm,
		output wire lcd_hsync, 
		output wire lcd_vsync, 
		output wire lcd_de,
		output wire [10:0] o_x,
		output wire [10:0] o_y,
		output wire [16:0] addr
	);
	
	reg [10:0] counter_hs; 					// line position
	reg [10:0] counter_vs; 					// screen position

	localparam HS_STA = 0;					// horizontal sync start
	localparam HS_END = HS_STA + H_SYNC_WIDTH;		// horizontal sync end
	localparam HA_STA = H_BACK_PORCH;			// horizontal active pixel start
	localparam HA_END = HA_STA + H_LINE;			// horizontal active pixesl end
	
	localparam VS_STA = V_BACK_PORCH + V_LINE + V_FRONT_PORCH;	// vertical sync start
	localparam VS_END = VS_STA + V_SYNC_WIDTH;    			// vertical sync end
	localparam VA_STA = V_BACK_PORCH;			// vertical active pixel start
	localparam VA_END = VA_STA + V_LINE;			// vertical active pixel end
	
	localparam LINE   = H_BACK_PORCH + H_LINE + H_FRONT_PORCH;	// complete line (pixels)
	localparam SCREEN = V_BACK_PORCH + V_LINE + V_FRONT_PORCH;	// complete screen (lines)


	always @ (negedge clk)
	begin
    		if (rest_n == 1'b0)  // reset to start of frame
    		begin
    			counter_hs <= 0;
    			counter_vs <= 0;
    		end
		else  
		begin
			if (counter_hs == LINE)  // end of line
			begin
				counter_hs <= 0;
				counter_vs <= counter_vs + 1;
			end
			else
			begin
				counter_hs <= counter_hs + 1;
			end
			if (counter_vs == SCREEN)  // end of screen
				counter_vs <= 0;
		end
	end

	assign lcd_clk = (rest_n == 1) ? clk : 1'b0;
	assign lcd_pwm = (rest_n == 1) ? 1'b1 : 1'b0;
	assign lcd_hsync = ~((counter_hs >= HS_STA) & (counter_hs < HS_END));
	assign lcd_vsync = ~((counter_vs >= VS_STA) & (counter_vs < VS_END));
	assign lcd_de = (counter_hs >= HA_STA) & (counter_hs < HA_END-1) & (counter_vs >= VA_STA) & (counter_vs < VA_END-1); 
	
	assign o_x = (lcd_de == 0) ? 0 : (counter_hs - HA_STA);
	assign o_y = (lcd_de == 0) ? 0 : (counter_vs - VA_STA);
	assign addr = o_y * H_LINE + o_x;
 	
endmodule
