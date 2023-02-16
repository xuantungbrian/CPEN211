module ALU(Ain, Bin, ALUop, out, Z);
  input [15:0] Ain, Bin;
  input [1:0] ALUop;
  output [15:0] out;		//Declarations
  output Z;
  reg [15:0] out;
  reg Z;
  
  
  always @(*) begin //The idea is right but the syntax may not
  	case (ALUop)
      2'b00: {Z, out} <= Ain + Bin;
      2'b01: {Z, out} <= Ain - Bin;		//What if the subtracting value is also a negative (You are adding) Can have 17 bits
      2'b10: begin
        				out <= Ain & Bin;
        				Z<=1'b0;
      				end
      2'b11: begin
        				out <= ~Bin;
        				Z<=1'b0;
      				end
	default: {Z, out} <= {17{1'bx}};
    endcase												
  end  
endmodule
