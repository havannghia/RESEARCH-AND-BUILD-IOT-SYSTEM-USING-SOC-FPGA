//////////////////////////////////////////////////////////////////////
////                                                              ////
//// registerInterface.v                                          ////
////                                                              ////
//// This file is part of the i2cSlave opencores effort.
//// <http://www.opencores.org/cores//>                           ////
////                                                              ////
//// Module Description:                                          ////
//// You will need to modify this file to implement your 
//// interface.
//// Add your control and status bytes/bits to module inputs and outputs,
//// and also to the I2C read and write process blocks  
////                                                              ////
//// To Do:                                                       ////
//// 
////                                                              ////
//// Author(s):                                                   ////
//// - Steve Fielding, sfielding@base2designs.com                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2008 Steve Fielding and OPENCORES.ORG          ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE. See the GNU Lesser General Public License for more  ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from <http://www.opencores.org/lgpl.shtml>                   ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
`include "i2cSlave_define.v"


module registerInterface (
  clk,
  //I2C
  addr,
  dataIn,
  writeEn,
  dataOut,
  
  //avalon
  avalon_read,
  avalon_write,
  avalon_addr,
  avalon_dataIn,
  avalon_dataOut
);

input clk;

//I2c
input [7:0] addr;
input [7:0] dataIn;
input writeEn;
output reg [7:0] dataOut;

//Avalon
input avalon_read;
input avalon_write;
input [7:0] avalon_addr;
input [7:0] avalon_dataIn;
output reg [7:0] avalon_dataOut;

//memory
reg [7:0] mem [255:0];

// --- I2C Read
always @(posedge clk) begin
  dataOut <= mem[addr];
  if (avalon_read) begin
	avalon_dataOut <= mem[avalon_addr];
  end
end

// --- I2C Write
always @(posedge clk) begin
  if (writeEn == 1'b1) begin
	//if (addr >= 8'h0 && addr <= 8'h7f) begin//0-127
		mem[addr] <= dataIn;
	//end
  end
  if (avalon_write) begin
	//if (avalon_addr >= 8'h80 && avalon_addr <= 8'hff) begin //128-255
		mem[avalon_addr] <= avalon_dataIn;
	//end
  end
end

endmodule


 
