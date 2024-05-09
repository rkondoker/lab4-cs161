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

`timescale 1ns / 1ps

module processor_tb;

// Inputs
reg clk;
reg rst;

// Outputs
wire [31:0] prog_count;
wire [5:0] instr_opcode;
wire [4:0] reg1_addr;
wire [31:0] reg1_data;
wire [4:0] reg2_addr;
wire [31:0] reg2_data;
wire [4:0] write_reg_addr;
wire [31:0] write_reg_data;

// -------------------------------------------------------
// Setup output file for possible debugging uses
// -------------------------------------------------------
initial begin
    $dumpfile("lab04.vcd");
    $dumpvars(0);
end

initial begin 
	$readmemb("init.coe", uut.DIG_RAMDualAccess_i7.memory,0,255);
end 

lab04 uut (
    .clk(clk),
    .rst(rst),
    .PC(prog_count),
    .opcode(instr_opcode),
    .src1_addr(reg1_addr),
    .src1_out(reg1_data),
    .src2_addr(reg2_addr),
    .src2_out(reg2_data),
    .dst_addr(write_reg_addr),
    .dst_data(write_reg_data)
);
  
initial begin 
    clk = 0; rst = 1; #50; 
    clk = 1; rst = 1; #45; 
    rst = 0; #5; clk = 0;  
         
    forever begin 
        #50 clk = ~clk;
    end 
end 

reg[31:0] result;
reg[31:0] expected;
integer last_instruction;

integer passedTests = 0;
integer totalTests = 0;

task test_case(
    input [31:0] prog_count_exp,
    input [5:0] instr_opcode_exp,
    input [4:0] reg1_addr_exp,
    input [31:0] reg1_data_exp,
    input [4:0] reg2_addr_exp,
    input [31:0] reg2_data_exp,
    input [4:0] write_reg_addr_exp,
    input [31:0] write_reg_data_exp
);
    begin
        @(posedge clk); 
        totalTests = totalTests + 1;
        if (prog_count     === prog_count_exp     &&
            instr_opcode   === instr_opcode_exp   &&
            reg1_addr      === reg1_addr_exp      &&
            reg1_data      === reg1_data_exp      &&
            reg2_addr      === reg2_addr_exp      &&
            reg2_data      === reg2_data_exp      &&
            write_reg_addr === write_reg_addr_exp &&
            write_reg_data === write_reg_data_exp) 
        begin
            passedTests = passedTests + 1;
            $display("passed.");
        end else begin
            $display("\nfailed - expected: PC = %h, opcode = %h, src1_addr = %h, src1_out = %h, src2_addr = %h, src2_out = %h, dst_addr = %h dst_data = %h",
                     prog_count_exp, instr_opcode_exp, reg1_addr_exp, reg1_data_exp, reg2_addr_exp, reg2_data_exp, write_reg_addr_exp, write_reg_data_exp);
            $display("       - got     : PC = %h, opcode = %h, src1_addr = %h, src1_out = %h, src2_addr = %h, src2_out = %h, dst_addr = %h dst_data = %h",
                     prog_count, instr_opcode, reg1_addr, reg1_data, reg2_addr, reg2_data, write_reg_addr, write_reg_data);
        end
    end
endtask

initial begin
   
   /* Individual tests... Check the result after each instruction */
    @(negedge rst); // Wait for reset
    @(negedge clk); // Skip LW instruction

    $write("Test Case %0d: lw $v0 31($zero)...", totalTests+1);
    test_case(32'h0, 6'h23, 5'h0, 32'h0, 5'h2, 32'h0, 5'h2, 32'h56);

    #100; $write("Test Case %0d: add $v1 $v0 $v0...", totalTests+1);
    test_case(32'h4, 6'h00, 5'h2, 32'h56, 5'h2, 32'h56, 5'h3, 32'hAC);

    #100; $write("Test Case %0d: sw $v1 132($zero)...", totalTests+1);
    test_case(32'h8, 6'h2b, 5'h0, 32'h0, 5'h3, 32'hAC, 5'h3, 32'h84);

    #100; $write("Test Case %0d: sub $a0 $v1 $v0...", totalTests+1);
    test_case(32'hC, 6'h00, 5'h3, 32'hac, 5'h2, 32'h56, 5'h4, 32'h56);

    #100; $write("Test Case %0d: addi $a1 $v1 12...", totalTests+1);
    test_case(32'h10, 6'h08, 5'h3, 32'hac, 5'h5, 32'h00, 5'h5, 32'hB8);

    #100; $write("Test Case %0d: and $a2 $a1 $v1...", totalTests+1);
    test_case(32'h14, 6'h00, 5'h5, 32'hb8, 5'h3, 32'hac, 5'h6, 32'hA8);

    #100; $write("Test Case %0d: or $a3 $a2 $v0...", totalTests+1);
    test_case(32'h18, 6'h00, 5'h6, 32'ha8, 5'h2, 32'h56, 5'h7, 32'hfe);

    #100; $write("Test Case %0d: nor $t0 $a2 $v0...", totalTests+1);
    test_case(32'h1c, 6'h00, 5'h6, 32'ha8, 5'h2, 32'h56, 5'h8, 32'hffffff01);

    #100; $write("Test Case %0d: slt $a2 $a1 $a0...", totalTests+1);
    test_case(32'h20, 6'h00, 5'h5, 32'hb8, 5'h4, 32'h56, 5'h6, 32'h0);

    #100; $write("Test Case %0d: beq $a2 $zero -8...", totalTests+1);
    test_case(32'h24, 6'h04, 5'h5, 32'hb8, 5'h0, 32'h00, 5'h1f, 32'hb8);

    #100; $write("Test Case %0d: lw $t0 132($zero)...", totalTests+1);
    test_case(32'h28, 6'h23, 5'h0, 32'h0, 5'h8, 32'hffffff01, 5'h8, 32'hac);

    $display("------------------------------------------------------------------");
    $display("Testing complete\nPassed %0d / %0d tests.",passedTests,totalTests);
    $display("------------------------------------------------------------------");
    $finish();
end
endmodule
