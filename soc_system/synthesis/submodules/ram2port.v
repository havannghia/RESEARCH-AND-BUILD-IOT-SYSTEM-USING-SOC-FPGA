module ram2port  (
	//	Global signals
	input clock,
	
	//	Write
	input [3:0] wraddress,
	input wren,
	input [31:0]data,
	
	//	Read
	input [3:0]rdaddress,
	output reg [31:0]q			
 );
 
 reg [31:0] ram [0:15];
 
 always@(posedge clock)
 begin
	if(wren) begin
		ram[wraddress] <= data;
	end
 end
 
 always@(posedge clock) 
 begin
	q <= ram[rdaddress];
 end
 
 endmodule
 