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

`define ALU_AND  		 4'b0000
`define ALU_OR   		 4'b0001
`define ALU_ADD  		 4'b0010
`define ALU_SUBTRACT   4'b0110
`define ALU_LESS_THAN  4'b0111
`define ALU_NOR        4'b1100

`define WORD_SIZE 32 

module alu (
	input wire [3:0] alu_control,  
	input wire [`WORD_SIZE-1:0] A, 
	input wire [`WORD_SIZE-1:0] B , 
	output reg zero, 
	output reg [`WORD_SIZE-1:0] result
);

reg [`WORD_SIZE-1:0] temp ; 

// ---------------------------------------------------------
// Parameters 
// --------------------------------------------------------- 

always @(alu_control or A or B) 
begin

	case (alu_control)   // R Type Instruction 	
		`ALU_AND :       result = A & B; 
		`ALU_OR :        result = A | B; 
		`ALU_ADD :       result = A + B; 
		`ALU_SUBTRACT :  result = A - B; 
		`ALU_NOR :       result = ~(A | B) ; 
		`ALU_LESS_THAN : result = $signed(A) < $signed(B) ?  1 : 0;
		
		default : temp = { `WORD_SIZE {1'b0} } ; 
	
	endcase

	// Final results 
	zero = (result == 0) ? 1 : 0; 
end 

endmodule
