module shifter_tb;
  reg [15:0] in;
  reg [1:0] shift;
  wire [15:0] sout;
  reg err;  
  
  
  shifter DUT(in, shift, sout);
  
  task my_checker;
    input [15:0] expected_sout;
    begin 
      if ( shifter_tb.DUT.sout !== expected_sout)begin 
        $display("ERROR, the shifter output, %b, does not match the expected %b", shifter_tb.DUT.sout, expected_sout);
        err=1'b1;
	end	
	end
      endtask
  

  initial begin
    err=1'b0; #10; in=16'b1011000011001111; #10;
  
    //Test 00
    shift=2'b00; #10;				//Expected 16'b1011000011001111
    my_checker(16'b1011000011001111);#10;
    
  	//Test 01
    shift = 2'b01; #10;		
    my_checker(16'b0110000110011110);#10;
    
    //Test 10
    shift = 2'b10; #10;
    my_checker(16'b0101100001100111);#10;
    
    
    //Test 11
    shift = 2'b11; #10;
    my_checker(16'b1101100001100111);#10;
	 #500;
    
    if (~err) $display("PASSED");
		else $display("FAILED");
		$stop; 
  end
endmodule
