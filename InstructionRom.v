`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:22:49 04/13/2016 
// Design Name: 
// Module Name:    InstructionRom 
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

//  read_enable ����ʹ�ܶ� read_data ��������˿� address �����ַ
//  ʵ�ֹ��� �� read_enable == 1����Ч ��˹��� ROM�͵�ַ��ָ���λ 
//	 ���32λָ�[address] ~ [address + 3]������
//  myRomData.txt��16������д 
module InstructionRom(
	input [31:0]address,
	input read_enable,
	output reg[31:0]read_data
	);
	 
	 reg [7:0] member [0:255];
	 
	 initial
		$readmemh ("myRomData.list", member);
	 always @(address or read_enable)
		begin
			if (read_enable == 1)
			read_data = {member[address], member[address + 1], member[address + 2]
							, member[address + 3]};
		end
endmodule 