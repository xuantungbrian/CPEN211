module cpu(clk,reset,s,load,in,out,N,V,Z,w); 
	input clk, reset, s, load;
	input [15:0] in;
	output [15:0] out;
	output N, V, Z, w;
	wire [15:0] Bdecoder, sximm8, sximm5, mdata;
	wire [2:0] opcode, readnum, writenum, nsel;
	wire [1:0] op, shift, ALUop;
	wire write, loada, loadb, asel, bsel, loadc, loads;
	wire [3:0] vsel;
	wire [2:0] Z_out;
	wire [7:0] PC;
	
	assign N=Z_out[2]; //assign 3 bit Z_out (output from datapath) to 3 bit status N, V, Z
	assign V=Z_out[1];
	assign Z=Z_out[0];
	assign mdata=16'b0; //mdata and PC in lab 6 is 0
	assign PC=16'b0;
	
	RLEC r8 (in, load, clk, Bdecoder); //Instantiate register with load enable with the 16-bits input in
	Idecoder I0 (Bdecoder, opcode, op, nsel, readnum, writenum, shift, sximm8, sximm5, ALUop); //Instruction decoder
	FSM FSM (reset, s, clk, vsel, loada, loadb, asel, bsel, loadc, loads, write, w, nsel, op, opcode); //Finite state machine with 21 states, determining inputs for datapath, output w in Wait state
	datapath DP (clk , readnum, vsel, loada, loadb, shift, asel, bsel, ALUop , loadc, loads, writenum , write, Z_out, out, sximm5, sximm8, mdata, PC); //datapath from lab5 with changes, output out, N, V, Z (status bits) 
	
	
endmodule		
	
	
module FSM(reset, s, clk, vsel, loada, loadb, asel, bsel, loadc, loads, write, w, nsel, op, opcode);
  input reset, s, clk;
  input [2:0] opcode;
  input [1:0] op;
  output reg write, loada, loadb, asel, bsel, loadc, loads, w;
  output reg [2:0] nsel;
  output reg [3:0] vsel;
  reg [4:0] state;
  
  
  always @(posedge clk) begin //Implementing finite state machine with 21 states, return to state 0 (wait) when reset=1
		if (reset) 
			state<=5'b0;
		else begin
			case (state)
				5'd0: state<=s?5'd1:5'd0;
				5'd1: if (opcode==3'b101 && op==2'b00) state<=5'd2; //decode, probably copy the decode module lower
						else if (opcode==3'b101 && op==2'b01) state<=5'd6;
						else if (opcode==3'b101 && op==2'b10) state<=5'd9;
						else if (opcode==3'b101 && op==2'b11) state<=5'd13;
						else if (opcode==3'b110 && op==2'b10) state<=5'd17;
						else if (opcode==3'b110 && op==2'b00) state<=5'd18;
						else state=5'dx;
				//ADD (d2 to d5)
				5'd2: state<=5'd3; //GetA
				5'd3: state<=5'd4; //GetB
				5'd4: state<=5'd5; //Add
				5'd5: state<=5'd0; //Writereg
				//CMP (d6 to d8)
				5'd6: state<=5'd7; //GetA
				5'd7: state<=5'd8;	//GetB
				5'd8: state<=5'd0; //SUB and have the status
				//AND (d9 to d12)
				5'd9: state<=5'd10; //GetA
				5'd10: state<=5'd11; //GetB
				5'd11: state<=5'd12; //AND
				5'd12: state<=5'd0; //Writereg
				//MVN (d13 to d16)
				5'd13: state<=5'd14;//GetA=0
				5'd14: state<=5'd15;//GetB
				5'd15: state<=5'd16;//MVN
				5'd16: state<=5'd0;//Writereg
				//MOVImm
				5'd17: state<=5'd0;
				//MOVReg
				5'd18: state<=5'd19; //GetA=0
				5'd19: state<=5'd20; //GetB
				5'd20: state<=5'd21; //Add
				5'd21: state<=5'd0; //Writereg
				default: state<=5'bx; 
			endcase
		end
	end
		
	always @* begin //output of each state
			case (state)
				5'd0: begin //Wait						
							vsel<=4'bx;
							loada<=1'bx;
							loadb<=1'bx;
							asel<=1'bx;
							bsel<=1'bx;
							loadc<=1'bx; 
							loads<=1'bx;
							write<=1'b0;
							if (s==1'b1) w<=1'b0;
							else w<=1'b1;
							nsel<=3'bx;
						end
				5'd1: begin //Decode 		
							vsel<=4'bx;
							loada<=1'bx;
							loadb<=1'bx;
							asel<=1'bx;
							bsel<=1'bx;
							loadc<=1'bx;
							loads<=1'bx;
							write<=1'b0;
							w<=1'b0;
							nsel<=3'bx;
						end						
				5'd2: begin //ADD GetA
							vsel<=4'b0;
							loada<=1'b1;
							loadb<=1'b0;
							asel<=1'b0;
							bsel<=1'b0;
							loadc<=1'b0;
							loads<=1'bx;
							write<=1'b0;
							w<=1'b0;
							nsel<=3'b001;
						end
				5'd3: begin //ADD GetB 
							vsel<=4'b0;
							loada<=1'b0;
							loadb<=1'b1;
							asel<=1'b0;
							bsel<=1'b0;
							loadc<=1'b0;
							loads<=1'bx;
							write<=1'b0;
							w<=1'b0;
							nsel<=3'b100;
						end
				5'd4: begin //ADD Add 
							vsel<=4'b0;
							loada<=1'b0;
							loadb<=1'b0;
							asel<=1'b0;
							bsel<=1'b0;
							loadc<=1'b1;
							loads<=1'bx;
							write<=1'b0;
							w<=1'b0;
							nsel<=3'b0; 
						end
				5'd5: begin //ADD WriteReg
							vsel<=4'b1;
							loada<=1'b0;
							loadb<=1'b0;
							asel<=1'b0;
							bsel<=1'b0;
							loadc<=1'b0;
							loads<=1'bx;
							write<=1'b1;
							w<=1'b0;
							nsel<=3'b010; 
						end
				5'd6: begin //CMP GetA
							vsel<=4'b0;
							loada<=1'b1;
							loadb<=1'b0;
							asel<=1'b0;
							bsel<=1'b0;
							loadc<=1'b0;
							loads<=1'b0;
							write<=1'b0;
							w<=1'b0;
							nsel<=3'b001;
						end
				5'd7: begin //CMP GetB 
							vsel<=4'b0;
							loada<=1'b0;
							loadb<=1'b1;
							asel<=1'b0;
							bsel<=1'b0;
							loadc<=1'b0;
							loads<=1'b0;
							write<=1'b0;
							w<=1'b0;
							nsel<=3'b100;
						end
				5'd8: begin //CMP SUB 
							vsel<=4'b0;
							loada<=1'b0;
							loadb<=1'b0;
							asel<=1'b0;
							bsel<=1'b0;
							loadc<=1'b1;
							loads<=1'b1;
							write<=1'b0;
							w<=1'b0;
							nsel<=3'b0; 
						end
				5'd9: begin //AND GetA
							vsel<=4'b0;
							loada<=1'b1;
							loadb<=1'b0;
							asel<=1'b0;
							bsel<=1'b0;
							loadc<=1'b0;
							loads<=1'bx;
							write<=1'b0;
							w<=1'b0;
							nsel<=3'b001;
						end
				5'd10: begin //AND GetB 
							vsel<=4'b0;
							loada<=1'b0;
							loadb<=1'b1;
							asel<=1'b0;
							bsel<=1'b0;
							loadc<=1'b0;
							loads<=1'bx;
							write<=1'b0;
							w<=1'b0;
							nsel<=3'b100;
						end
				5'd11: begin //AND And 
							vsel<=4'b0;
							loada<=1'b0;
							loadb<=1'b0;
							asel<=1'b0;
							bsel<=1'b0;
							loadc<=1'b1;
							loads<=1'bx;
							write<=1'b0;
							w<=1'b0;
							nsel<=3'b0; 
						end
				5'd12: begin //AND WriteReg
							vsel<=4'b1;
							loada<=1'b0;
							loadb<=1'b0;
							asel<=1'b0;
							bsel<=1'b0;
							loadc<=1'b0;
							loads<=1'bx;
							write<=1'b1;
							w<=1'b0;
							nsel<=3'b010; 
						end
				5'd13: begin //MVN GetA=0
							vsel<=4'b0;
							loada<=1'b0;
							loadb<=1'b0;
							asel<=1'b1;
							bsel<=1'b0;
							loadc<=1'b0;
							loads<=1'bx;
							write<=1'b0;
							w<=1'b0;
							nsel<=3'b0;
						end
				5'd14: begin //MVN GetB 
							vsel<=4'b0;
							loada<=1'b0;
							loadb<=1'b1;
							asel<=1'b1;
							bsel<=1'b0;
							loadc<=1'b0;
							loads<=1'bx;
							write<=1'b0;
							w<=1'b0;
							nsel<=3'b100;
						end
				5'd15: begin //MVN  
							vsel<=4'b0;
							loada<=1'b0;
							loadb<=1'b0;
							asel<=1'b1;
							bsel<=1'b0;
							loadc<=1'b1;
							loads<=1'bx;
							write<=1'b0;
							w<=1'b0;
							nsel<=3'b0; 
						end
				5'd16: begin //MVN WriteReg
							vsel<=4'b1;
							loada<=1'b0;
							loadb<=1'b0;
							asel<=1'b0;
							bsel<=1'b0;
							loadc<=1'b0;
							loads<=1'bx;
							write<=1'b1;
							w<=1'b0;
							nsel<=3'b010; 
						end
				5'd17: begin //MOVImm
							vsel<=4'b100;
							loada<=1'b0;
							loadb<=1'b0;
							asel<=1'b0;
							bsel<=1'b0;
							loadc<=1'b0;
							loads<=1'bx;
							write<=1'b1;
							w<=1'b0;
							nsel<=3'b001; 
						end
				5'd18: begin //MOVReg GetA=0
							vsel<=4'b0;
							loada<=1'b0;
							loadb<=1'b0;
							asel<=1'b1;
							bsel<=1'b0;
							loadc<=1'b0;
							loads<=1'bx;
							write<=1'b0;
							w<=1'b0;
							nsel=3'b0;
						end
				5'd19: begin //MOVReg GetB 
							vsel<=4'b0;
							loada<=1'b0;
							loadb<=1'b1;
							asel<=1'b1;
							bsel<=1'b0;
							loadc<=1'b0;
							loads<=1'bx;
							write<=1'b0;
							w<=1'b0;
							nsel<=3'b100;
						end
				5'd20: begin //MOVReg Add  
							vsel<=4'b0;
							loada<=1'b0;
							loadb<=1'b0;
							asel<=1'b1;
							bsel<=1'b0;
							loadc<=1'b1;
							loads<=1'bx;
							write<=1'b0;
							w<=1'b0;
							nsel<=3'b0; 
						end
				5'd21: begin //MOVReg WriteReg
							vsel<=4'b1;
							loada<=1'b0;
							loadb<=1'b0;
							asel<=1'b0;
							bsel<=1'b0;
							loadc<=1'b0;
							loads<=1'bx;
							write<=1'b1;
							w<=1'b0;
							nsel<=3'b010; 
						end				
				default: begin
								vsel<=4'bx;
								loada<=1'bx;
								loadb<=1'bx;
								asel<=1'bx;
								bsel<=1'bx;
								loadc<=1'bx;
								loads<=1'bx;
								write<=1'bx;
								w<=1'bx;
								nsel<=3'bx;
							end
			endcase
		end
	
endmodule



module Idecoder(in, opcode, op, nsel, readnum, writenum, shift, sximm8, sximm5, ALUop);
	input [15:0] in;
	input [2:0] nsel;
	output [2:0] opcode, readnum, writenum;
	reg [2:0] readnum, writenum;
	output [1:0] op, shift, ALUop;
	output [15:0] sximm8;
	output [15:0] sximm5;
	wire [2:0] Rm, Rd, Rn;
	
	assign opcode[2:0] = in[15:13] ; //divide and assign bits from 16-bits "in" to inputs to finite state machine and datapath
	assign op[1:0] = in[12:11];
	assign Rm[2:0] = in[2:0];
	assign Rd[2:0] = in[7:5];
	assign Rn[2:0] = in[10:8];
	assign shift[1:0] = in[4:3];
	assign sximm8[15:0] = {{8{in[7]}}, in[7:0] };
	assign sximm5[15:0] = {{11{in[4]}}, in[4:0]};
	assign ALUop[1:0] = in[12:11];
	
	always @* begin //Implementing the MUX for readnum and writenum with 3 inputs Rn, Rd, Rm
		case (nsel)
			3'b001:begin
						readnum<=Rn;
						writenum<=Rn;
					 end
			3'b010:begin
						readnum<=Rd;
						writenum<=Rd;
					 end
			3'b100:begin
						readnum<=Rm;
						writenum<=Rm;
					 end
			default:begin
						readnum<=3'bx;
						writenum<=3'bx;
					  end
		endcase
	end
endmodule


























	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
