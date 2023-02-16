module cpu_tb();
	reg clk, reset, s, load;
	reg [15:0] in;
	wire N, V, Z, w;
	wire [15:0] out;
	reg err;
	
	cpu DUT (.clk(clk), .reset(reset), .s(s), .load(load), .in(in), .out(out), .N(N), .V(V), .Z(Z), .w(w)); //Intstantiate module cpu to test
	
	
	task checker_w; //Task check w in wait state (state 0)
		input expected_w;
		begin
			if ( cpu_tb.DUT.w !== expected_w) begin 
			  $display(" w is %b, expected is %b", cpu_tb.DUT.w, expected_w);
					err=1'b1; 
			end
		end
	endtask
  
  
  
	task checker_out; //Task check output N, V, Z, out of cpu module 
		input [15:0] expected_out;
		input expected_N;
		input expected_V;
		input expected_Z;
		begin
			if ( cpu_tb.DUT.out !== expected_out) begin 
			  $display(" out is %b, expected is %b", cpu_tb.DUT.out, expected_out);
					err=1'b1; 
			end
			
			if ( cpu_tb.DUT.N !== expected_N) begin 
			  $display(" N is %b, expected is %b", cpu_tb.DUT.N, expected_N);
					err=1'b1; 
			end
			
			if ( cpu_tb.DUT.V !== expected_V) begin 
			  $display(" V is %b, expected is %b", cpu_tb.DUT.V, expected_V);
					err=1'b1; 
			end
			
			if ( cpu_tb.DUT.Z !== expected_Z) begin 
			  $display(" Z is %b, expected is %b", cpu_tb.DUT.Z, expected_Z);
					err=1'b1; 
			end
	
		end
	endtask
  
	
	
	
	
	initial begin //create clock wave until $stop
		clk = 0; #5;
		forever begin
			clk=1; #5;
			clk=0; #5;
		end
	end
	
	
	initial begin //start checking test cases
		reset=1'b1; err=1'b0; #10;
		reset=1'b0;
		checker_w(1'b1);
		
		//MOV R0, #7 Test store MOVImm and store in R0
		in=16'b1101000000000111; load=1'b1; s=1'b1; #10; s=1'b0; #50;
		if ( cpu_tb.DUT.DP.REGFILE.R0 !== 16'd7) begin 
			  $display(" R0 is %b, expected is 7", cpu_tb.DUT.DP.REGFILE.R0);
					err=1'b1; 
			end
		checker_out(16'bx, 1'bx, 1'bx, 1'bx);
		checker_w(1'b1);
		
		
		//MOV R1, R0 Test MOVReg and store in R1
		in=16'b1100000000100000; load=1'b1; s=1'b1; #10; s=1'b0; #50;
		if ( cpu_tb.DUT.DP.REGFILE.R1 !== 16'd7) begin 
			  $display(" R1 is %b, expected is 7", cpu_tb.DUT.DP.REGFILE.R1);
					err=1'b1; 
			end
		checker_out(16'd7, 1'bx, 1'bx, 1'bx);
		checker_w(1'b1);
		
		
		//ADD R2, R0, R1, LSR#1 Test ADD, LSR, store in R2
		in=16'b1010000001010001; load=1'b1; s=1'b1; #10; s=1'b0; #50;
		if ( cpu_tb.DUT.DP.REGFILE.R2 !== 16'd10) begin 
			  $display(" R2 is %b, expected is 10", cpu_tb.DUT.DP.REGFILE.R2);
					err=1'b1; 
			end
		checker_out(16'd10, 1'bx, 1'bx, 1'bx);
		checker_w(1'b1);
		
		
		//CMP R0, R1 Test CMP, status N=0, V=0, Z=1		
		in=16'b1010100000000001; load=1'b1; s=1'b1; #10; s=1'b0; #40;
		checker_out(16'b0, 1'b0, 1'b0, 1'b1);
		checker_w(1'b1);
		
		
		//AND R3, R0, R2
		in=16'b1011000001100010; load=1'b1; s=1'b1; #10; s=1'b0; #50;
		if ( cpu_tb.DUT.DP.REGFILE.R3 !== 16'd2) begin 
			  $display(" R3 is %b, expected is 2", cpu_tb.DUT.DP.REGFILE.R3);
					err=1'b1; 
			end
		checker_out(16'd2, 1'bx, 1'bx, 1'bx);
		checker_w(1'b1);
		
		
		//MVN R4, R3
		in=16'b1011100010000011; load=1'b1; s=1'b1; #10; s=1'b0; #50;
		if ( cpu_tb.DUT.DP.REGFILE.R4 !== 16'b1111111111111101) begin 
			  $display(" R4 is %b, expected is -2", cpu_tb.DUT.DP.REGFILE.R4);
					err=1'b1; 
			end
		checker_out(16'b1111111111111101, 1'bx, 1'bx, 1'bx);
		checker_w(1'b1);
		
		if (~err) $display("PASSED");
		else $display("FAILED");
		$stop; 
	end
endmodule	
		
		
		
		