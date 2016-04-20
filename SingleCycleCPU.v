`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    17:52:55 04/18/2016
// Design Name:
// Module Name:    SingleCycleCPU
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
module SingleCycleCPU(
		input clk,

// �����ź�
input Extsel, input PCWre, input InsMemRW, input RegOut, input
     RegWre, input ALUSrcB, input ALUM2Reg, input PCSrc, input DataMemRW,
input [2:0] ALUOp,
// �м�����
input [31:0]_instruction,
input [31:0]_PcOut,
input [31:0]_PcIn,
input _zero,
input [31:0]_extendOut,
input [4:0]_thirdRg,
input [31:0]_RgData1,
input [31:0]_RgData2,
input [31:0]_WriteData,
input [31:0]_ALUResult,
input [31:0]_DataOut,
input [31:0]_PcIndect

);
//end
// ��ȡָ��
// pd -> InstructionRom ->
PC pc(
			.clk(clk),                         // ʱ���ź�
			.reset(),	                         // PC�����ź�
			.PCWre(PCWre),	                   // CU�����źţ������Ƿ�ͣ��
			.instructionInput(_PcIn),	         // ָ�����룬����PC�жϺ����
			.instructionOutput(_PcOut)		     // ָ�����
		);

InstructionRom instructionrom(
			.address(_PcOut),  		             // �����ַ
			.RW(InsMemRW),	           // ����ʹ�ܶ�
			.read_data(_instruction)			     // ��������˿�
		);



// ����ָ��
// CU -> Registers ->
Control_Unit cu(
      _instruction[31:26],
      _zero,
      Extsel,                            // ����λ��չ 1���з�����չ, ֻ���߼���������޷�����չ
      PCWre,                             // PC��enable 1: ���� halt : 0;
      InsMemRW,                          // ָ��洢����д�ˣ�ֻ�ܶ���һֱΪ0
      RegOut,                            // 0: rt; 1: rd
      RegWre,                            // д��ͨ�üĴ���ʹ�ܶ��ź� 1�� д��
      ALUOp,                             // ALU����������
      ALUSrcB,                           // ALU�����ݶ�ѡ��
      ALUM2Reg,                          // ֻ��lw��1
      PCSrc,                             // beq PCSrc = zero others: 0
      DataMemRW                          // 1:д�����ݴ洢����ֻ��lw����0����
		);

SignOrZeroExtend signorzeroextend(
      .ExtSel(Extsel),                   // �Ƿ��з�����չ
      .immediate(_instruction[15:0]),    // ������
      .DataOut(_extendOut)               // ���
    );


TwoInOneSelector5Bit registersSelector(
      .ZeroInput(_instruction[20:16]),
      .OneInput(_instruction[15:11]),
      .Control(RegOut),
      .DataOutput(_thirdRg)
    );

GeneralRegisters generalregisters(
      .ReadReg1Address(_instruction[25:21]),
      .ReadReg2Address(_instruction[20:16]),
      .WriteRegAddress(_thirdRg),
      .DataOfWrite(_WriteData),
      .WriteControl(RegWre),
      .Clock(clk),
      .CleanAllControl(),
      .ReadData1(_RgData1),
      .ReadData2(_RgData2)
    );


// ִ��ָ��
// ALU ->

ALU alu(
      .InputDataA(_RgData1),                // �Ĵ���A
      .InputDataB(_RgData2),                // �Ĵ���B
      .ImmediateDataB(_extendOut),          // ������
      .ALUSrcB(ALUSrcB),                    // CU�����źţ�����BΪ�Ĵ���ֵ����������
      .ALUOp(ALUOp),                        // CU�����źţ�������������
      .zero(_zero),                         // ����źţ�֪ͨCUΪ��ת�ź�
      .result(_ALUResult)                   // ������
    );


PCIncrementer pcincrementer(
      .PCWre(PCWre),
      .instructionInput(_PcOut),
      .instructionOutput(_PcIndect)
    );

PCJumper pcjumper(
      .PCSrc(PCSrc),                         // PC�����źţ������Ƿ���ת
      .instructionInput(_PcIndect),          // ԭָ��
      .addressOffset(_extendOut),            // ��תƫ��ֵ
      .instructionOutput(_PcIn)              // ���ָ��
    );



// д������
// DataRam -> (Registers)

DataRam dataram(
      .address(_ALUResult),                  // ���ݴ洢����ַ����˿�
      .DataIn(_RgData2),                     // ���ݴ洢����������˿�
      .RW(DataMemRW),                        // ���ݴ洢����д�����ź�
      .clk(clk),
      .DataOut(_DataOut)                     // ���ݴ洢����������˿�
    );

BitTwoInOneSelector32Bit DataOutputSelector(
      .ZeroInput(_ALUResult),
      .OneInput(_DataOut),
      .Control(ALUM2Reg),
      .DataOutput(_WriteData)
    );

// PC

endmodule
