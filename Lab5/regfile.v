module regfile(data_in, writenum, write, readnum, clk, data_out);
	input write,  clk;
	input [2:0] readnum, writenum;
	input [15:0] data_in;
	output [15:0] data_out;
	wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
	wire [7:0] AAND,BAND;
	wire [7:0] MUX;
	
	decoder3_8 D0 (writenum,BAND);
	decoder3_8 D1 (readnum, MUX);
	
	assign AAND[0]=BAND[0] & write;
	assign AAND[1]=BAND[1] & write;
	assign AAND[2]=BAND[2] & write;
	assign AAND[3]=BAND[3] & write;
	assign AAND[4]=BAND[4] & write;
	assign AAND[5]=BAND[5] & write;
	assign AAND[6]=BAND[6] & write;
	assign AAND[7]=BAND[7] & write;
	
	RLEC r0 (data_in, AAND[0], clk, R0);
	RLEC r1 (data_in, AAND[1], clk, R1);
	RLEC r2 (data_in, AAND[2], clk, R2);
	RLEC r3 (data_in, AAND[3], clk, R3);
	RLEC r4 (data_in, AAND[4], clk, R4);
	RLEC r5 (data_in, AAND[5], clk, R5);
	RLEC r6 (data_in, AAND[6], clk, R6);
	RLEC r7 (data_in, AAND[7], clk, R7);
	
	Mux8 M0 (MUX, R0, R1, R2, R3, R4, R5, R6, R7, data_out);
	
endmodule



module decoder3_8(in, out); //blocking, maybe wrong here, must check
	input [2:0] in;
	output [7:0] out;
	wire [7:0] out=1<<in;
endmodule



module Mux8(onehot, R0, R1, R2, R3, R4, R5, R6, R7, data_out);
	input [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
	input [7:0] onehot;
	output reg [15:0] data_out;
	always @* begin
		case (onehot)
		8'b00000001: data_out <= R0;
		8'b00000010: data_out <= R1;
		8'b00000100: data_out <= R2;
		8'b00001000: data_out <= R3;
		8'b00010000: data_out <= R4;
		8'b00100000: data_out <= R5;
		8'b01000000: data_out <= R6;
		8'b10000000: data_out <= R7;
		default: data_out <= 16'bxxxxxxxxxxxxxxxx;
		endcase
	end
endmodule


		
module RLEC (in, load, clk, out);
	parameter n=16;
	input [n-1:0] in;
	input load, clk;
	output [n-1:0] out;
	wire [n-1:0] med2;
	vDFF #(16) F0(clk, med2, out);
	assign med2=load?in:out;
endmodule
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
