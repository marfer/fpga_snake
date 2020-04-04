module data_out
	(	
		input wire clk_lcd, 
		output wire [7:0] R,
		output wire [7:0] G,
		output wire [7:0] B,
		input  wire den,
		input wire [7:0] pixel
	);

	// for now just assign specific color values
	assign R = (pixel == 8'h00) ? 8'hff : (pixel == 8'h01) ? 8'h00 : 8'hff;
	assign G = (pixel == 8'h00) ? 8'hff : (pixel == 8'h01) ? 8'h00 : 8'h00;
	assign B = (pixel == 8'h00) ? 8'hff : (pixel == 8'h01) ? 8'h00 : 8'h00;
	

endmodule
