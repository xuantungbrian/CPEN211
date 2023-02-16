module shifter(in, shift, sout);	//This is the code ofr the shifter block
  input [15:0] in;
  input [1:0] shift;	//Declarations
  output [15:0] sout;
  reg [15:0] sout;
  
  always @* begin
    case(shift)
      2'b00 : sout <= in;				//input 0111 = out 0111 STAYS THE SAME
      2'b01 : sout <= in << 1;	//input 0111 = out 1110 SHIFTS LEFT with zeros
      2'b10 : sout <= in >> 1;	//input 0111 = out 0011 SHIFTS RIGHT with zeros
      2'b11 : begin 
        sout <= in >> 1; //input 0111 = out 0011 SHIFTS RIGHT 
        sout[15] <= in [15]; // Index 15 swaps value
      				end
      default: sout <= {16{1'bx}};
    endcase
  end 
endmodule
