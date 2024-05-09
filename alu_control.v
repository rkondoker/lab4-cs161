//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: 
// Email: 
// 
// Assignment name: 
// Lab section: 
// TA: 
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

//=========================================================================
//
// DO NOT CHANGE ANYTHING BELOW THIS COMMENT. IT IS PROVIDED TO MAKE SURE 
// YOUR LAB IS SUCCESSFULL. 
//
//=========================================================================

`timescale 1ns / 1ps

`define FUNCT_AND   		6'b100100
`define FUNCT_OR    		6'b100101
`define FUNCT_ADD   		6'b100000
`define FUNCT_SUBTRACT 	6'b100010
`define FUNCT_LESS_THAN 6'b101010
`define FUNCT_NOR 		6'b100111

`define ALU_AND  		 4'b0000
`define ALU_OR   		 4'b0001
`define ALU_ADD  		 4'b0010
`define ALU_SUBTRACT   4'b0110
`define ALU_LESS_THAN  4'b0111
`define ALU_NOR        4'b1100

module alu_control (	
	input wire [1:0]	alu_op,	
	input wire [5:0]	funct,	
	output reg [3:0] 	alu_control   
);

always @(*)
begin
	if (alu_op==2'b00) begin // LW and SW 
		alu_control = `ALU_ADD ; 
 	end else if (alu_op==2'b01) begin  // Branch 
		alu_control = `ALU_SUBTRACT ; 
 	end else begin 
		case (funct)   // R Type Instruction 
			`FUNCT_AND : 		 alu_control = `ALU_AND ; 
			`FUNCT_OR  : 		 alu_control = `ALU_OR ; 
			`FUNCT_ADD : 		 alu_control = `ALU_ADD ; 
			`FUNCT_SUBTRACT  : alu_control = `ALU_SUBTRACT ; 
			`FUNCT_LESS_THAN : alu_control = `ALU_LESS_THAN ; 
			`FUNCT_NOR  : 		 alu_control = `ALU_NOR ; 
			default    :       alu_control = `ALU_ADD ;      
	endcase 
  end // End else 

end  // End block 

endmodule
