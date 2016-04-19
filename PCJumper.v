`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    12:53:32 04/17/2016
// Design Name:
// Module Name:    PCJumper
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
module PCJumper(
    input PCSrc,                         // PC�����źţ������Ƿ���ת
    input [31:0] instructionInput,       // ԭָ��
    input [31:0] addressOffset,          // ��תƫ��ֵ
    output reg[31:0] instructionOutput   // ���ָ��
    );
    initial begin
      instructionOutput = 32'b0;
    end
    always @(instructionInput)
	     begin
		      if (PCSrc == 0)
				    instructionOutput = instructionInput;
				else
				    instructionOutput = instructionInput + (addressOffset << 2);
			end

endmodule
