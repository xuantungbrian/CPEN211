module lab5_top_tb;
  reg [3:0] KEY;
  reg [9:0] SW;
  wire [9:0] LEDR; 
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  reg CLOCK_50;
  reg [2:0] debug; //What is this for?
  reg err;

  lab5_top dut (.KEY(KEY),.SW(SW),.LEDR(LEDR),.HEX0(HEX0),.HEX1(HEX1),.HEX2(HEX2),.HEX3(HEX3),.HEX4(HEX4),.HEX5(HEX5),.CLOCK_50(CLOCK_50));

  
  task my_checker_LEDR;
    input [9:0] expected_LEDR;
    begin
    	if( lab5_top_tb.dut.LEDR !== expected_LEDR) begin
      $display("LEDR is %b, expected is %b", lab5_top_tb.dut.LEDR, expected_LEDR);
      err= 1'b1;
    	end 
    end 
  endtask 
  
  
  task my_checker_HEX;
    input [6:0] expected_HEX0;
    input [6:0] expected_HEX1;
    input [6:0] expected_HEX2;
    input [6:0] expected_HEX3;
    input [6:0] expected_HEX4;
    input [6:0] expected_HEX5;
    begin
      
      if ( lab5_top_tb.dut.HEX0 !== expected_HEX0) begin
        $display("HEX0 is %b, expected is %b", lab5_top_tb.dut.HEX0, expected_HEX0);
        err=1'b1;
      end       
      
      if ( lab5_top_tb.dut.HEX1 !== expected_HEX1) begin
        $display("HEX0 is %b, expected is %b", lab5_top_tb.dut.HEX1, expected_HEX1);
        err=1'b1;
      end 
          
      if ( lab5_top_tb.dut.HEX2 !== expected_HEX2) begin
        $display("HEX0 is %b, expected is %b", lab5_top_tb.dut.HEX2, expected_HEX2);
        err=1'b1;
      end 
          
      if ( lab5_top_tb.dut.HEX3 !== expected_HEX3) begin
        $display("HEX0 is %b, expected is %b", lab5_top_tb.dut.HEX3, expected_HEX3);
        err=1'b1;
      end 
          
      if ( lab5_top_tb.dut.HEX4 !== expected_HEX4) begin
        $display("HEX0 is %b, expected is %b", lab5_top_tb.dut.HEX4, expected_HEX4);
        err=1'b1;
      end 
          
      if ( lab5_top_tb.dut.HEX5 !== expected_HEX5) begin
        $display("HEX0 is %b, expected is %b", lab5_top_tb.dut.HEX5, expected_HEX5);
        err=1'b1;
      end 
    end
  endtask
    
    
  initial begin 
    //CLOCK_50 = 0;
    KEY[0] = 1'b0;
    #5;
    
    forever begin
    //CLOCK_50 = 1;
      KEY[0] = 1'b1;
    #5;
   //CLOCK_50 = 0; 
      KEY[0] = 1'b0;
    #5;
 		end
  end 


  initial begin
    err = 1'b0; #10;
    
    //TEST LEDR WITH SWITCH[9] on to use switches for datapath_in
    SW[9] = 1'b1; SW[8] = 1'bx; SW[7] = 1'b0; SW[6] = 1'b0; SW[5] = 1'b0; SW[4] = 1'b0; SW[3] = 1'b0; SW[2] = 1'b1; SW[1] = 1'b1; SW[0] = 1'b1; #10; // LEDR 00000111 First three LED's should light up 
    my_checker_LEDR( 10'b0000000111);
    
    //TEST LEDR WITH SWITCH[9] off
    SW[9] = 1'b0; SW[8] = 1'bx; SW[7] = 1'b0; SW[6] = 1'b0; SW[5] = 1'b0; SW[4] = 1'b0; SW[3] = 1'b0; SW[2] = 1'b1; SW[1] = 1'b1; SW[0] = 1'b1; #10; // LEDR 000000000
    my_checker_LEDR(10'b0000000000);
    
    
    //TEST HEX Output Will show number 123456
   // HEX0 = 7'b1111100; HEX1 = 7'b1101101; HEX2 = 7'b1100110; HEX3 = 7'b1001111; HEX4 = 7'b1011011; HEX5 = 7'b0000110;#10; //HEX should show 123456
   // my_checker_HEX( 7'b1111100, 7'b1101101, 7'b1100110, 7'b1001111, 7'b1011011, 7'b0000110);
    
    if (~err) $display("PASSED");
		else $display("FAILED");
		$stop; 
    
  end
endmodule      

      
      
      
    
