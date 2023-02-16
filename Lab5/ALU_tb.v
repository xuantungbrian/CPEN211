module ALU_tb;
	reg [15:0] Ain, Bin;
	reg [1:0] ALUop;
  reg err;
  wire [15:0] out;			//Declarations
  wire Z;
  
  ALU DUT( Ain, Bin, ALUop, out, Z);
  
  task my_checker;
    input [15:0] expected_out;
    input expected_Z;
    begin
      if (ALU_tb.DUT.out !== expected_out) begin
        $display("ERROR, the output, %b, does not match the expected %b", ALU_tb.DUT.out, expected_out);
        err=1'b1;
      end
      if (ALU_tb.DUT.Z !== expected_Z) begin
        $display("ERROR, the Z, %b, does not match the expected %b", ALU_tb.DUT.Z, expected_Z);
        err=1'b1;
      end
    end
  endtask
      
  initial begin
    err = 1'b0; #10;
    //my_checker(16'b0000000000000000, 1'b1); #10;
  	//Test ALUop=00; sum has 16 bit
    Ain = 16'b0000000000001111; Bin = 16'b000000000000111; ALUop = 2'b00;#10;
    my_checker(16'b0000000000010110, 1'b0); #10;
    
    
    //Test ALUop=00; sum has 17 bit
    Ain=16'b1111111111111111; Bin=16'b1111111111111110; ALUop=2'b00;#10;
    my_checker(16'b1111111111111101, 1'b1); #10;
               
    //Test ALUop=01; sub has 16 bit
    Ain=16'b0000000111000100; Bin=16'b0000000100000000; ALUop=2'b01;#10;
    my_checker(16'b0000000011000100, 1'b0); #10;
    
    //Test ALUop=01; sub is negative, just try something and hope verilog has it in their compiler
    //Test ALUop=00; sum is negative (adding 2 negative)
   
    //Test ALUop=10; and has 16 bit
    Ain=16'b1111111111111111; Bin=16'b1111111111111010; ALUop=2'b10;#10;
    my_checker(16'b1111111111111010, 1'b0);#10;
              
   
    //Test ALUop=11; neg has 16 bit
    Ain=16'b1111111111111111; Bin=16'b1111111111111110; ALUop=2'b11;#10;
    my_checker(16'b0000000000000001, 1'b0);#10;
	 #500;
    
    if (~err) $display("PASSED");
	 else $display("FAILED");
	 $stop; 
	end
endmodule
