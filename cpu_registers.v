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

`define MAX_REG 32
`define WORD_SIZE 32

module cpu_registers (
    input wire clk,	
    input wire rst , 
    input wire write_en,
    input wire [4:0] src1_addr,
    input wire [4:0] src2_addr, 
    input wire [4:0] dst_addr, 
    input wire [`WORD_SIZE-1:0]data_in    ,  
    output wire [`WORD_SIZE-1:0] src1_out  ,   
    output wire [`WORD_SIZE-1:0] src2_out  
);

// -----------------------------------------------
// Memory Words and Locations  
// ----------------------------------------------- 	
reg [`WORD_SIZE-1:0] RFILE [`MAX_REG-1:0];
integer i;

// --------------------------------------
// Read statements 
// -------------------------------------- 
assign src1_out = RFILE[src1_addr] ; 
assign src2_out = RFILE[src2_addr] ; 
	
// ---------------------------------------------
// Write  
// --------------------------------------------- 
always @(posedge clk)
begin 
    if (rst) begin 
        for (i = 0; i < `MAX_REG; i = i + 1) begin
            RFILE[i] <= { `WORD_SIZE {1'b0} } ; 
        end 
    end else begin 
        if (write_en) begin 
            RFILE[dst_addr] <= data_in;				
        end 	
    end
end
endmodule
