module datapath (clk , readnum, vsel, loada, loadb, shift, asel, bsel, ALUop , loadc, loads, writenum , write, datapath_in, Z_out, datapath_out);
  input [15:0] datapath_in;
  output [15:0] datapath_out;
  output Z_out;
  input write, vsel, loada, loadb, asel, bsel, loadc, loads, clk;
  input [2:0] readnum, writenum;
  input [1:0] shift, ALUop;
  wire [15:0] data_in, data_out, Ain, Bin, out, in, sout, Aloada;				//Aloada (A) means after 	(B) means before
  wire Z;
  
  
  assign data_in=vsel?datapath_in:datapath_out;
  assign Ain=asel?16'b0:Aloada;
  assign Bin=bsel?{11'b0, datapath_in[4:0]}:sout;
  
  regfile REGFILE (data_in, writenum, write, readnum, clk, data_out);
  RLEC A (data_out, loada, clk, Aloada);
  RLEC B (data_out, loadb, clk, in);
  shifter	U1 (in, shift, sout); //be careful with the name
  ALU			U2 (Ain, Bin, ALUop, out, Z); //be careful with the name
  RLEC C (out, loadc, clk, datapath_out);
  RLEC #(1) status (Z, loads, clk, Z_out);

endmodule




