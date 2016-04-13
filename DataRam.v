`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:07:34 04/13/2016 
// Design Name: 
// Module Name:    DataRam 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
// data ����������� address ��ַ���� read = 1 �� write = 1 д
// write��read��ͬʱΪ1
module DataRam(
   inout [7:0] data,
   input [7:0] address,
   input read,
   input write
   );
	reg [8:0] memory [0:255];
	assign data = read ? memory[address] : 4'bz;
	always @( posedge write)
         memory[address] = data;

endmodule
