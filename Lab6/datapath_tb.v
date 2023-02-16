module datapath_tb;
  reg [15:0] sximm8, sximm5, mdata;
  reg [7:0] PC;
  wire [15:0] datapath_out;
  wire [2:0] Z_out;
  reg write, loada, loadb, asel, bsel, loadc, loads, clk;
  reg [3:0] vsel;
  reg [2:0] readnum, writenum;
  reg [1:0] shift, ALUop;
  reg err;
  
  

  datapath dut ( .clk(clk), .readnum(readnum), .vsel(vsel), .loada(loada), .loadb(loadb), .shift(shift), .asel(asel), .bsel(bsel), .ALUop(ALUop), .loadc(loadc), .loads(loads), .writenum(writenum), .write(write), .Z_out(Z_out),.datapath_out(datapath_out), .sximm5(sximm5), .sximm8(sximm8), .mdata(mdata), .PC(PC)); //Instantiate datapath to test
  
  
  task my_checker; //Task check datapath_out and Z_out (3 bits status N, V, Z)
    input [15:0] expected_datapath_out;
    input [2:0]expected_Z_out;
    
    begin
      if ( datapath_tb.dut.datapath_out !== expected_datapath_out) begin 
        $display(" datapath_out is %b, expected is %b", datapath_tb.dut.datapath_out, expected_datapath_out);
				err=1'b1; 
			end
      if ( datapath_tb.dut.Z_out !== expected_Z_out)begin
        $display(" Z_out is %b, expected is %b", datapath_tb.dut.Z_out, expected_Z_out);
        err=1'b1;
    end
    end
  endtask
  
  task my_checker_MOV; //Task check value inside the register
		input [15:0] expected_R0;
		input [15:0] expected_R1;
		input [15:0] expected_R2;
		input [15:0] expected_R3;
		input [15:0] expected_R4;
		input [15:0] expected_R5;
		input [15:0] expected_R6;
		input [15:0] expected_R7;
		
		begin			
			if (datapath_tb.dut.REGFILE.R0 !== expected_R0) begin
        $display(" R0 is %b, expected is %b", datapath_tb.dut.REGFILE.R0, expected_R0);
				err=1'b1;
			end

			if (datapath_tb.dut.REGFILE.R1 !== expected_R1) begin
        $display(" R1 is %b, expected is %b", datapath_tb.dut.REGFILE.R1, expected_R1);
				err=1'b1;
			end
	
			if (datapath_tb.dut.REGFILE.R2 !== expected_R2) begin
        $display(" R2 is %b, expected is %b", datapath_tb.dut.REGFILE.R2, expected_R2);
				err=1'b1;
			end
			
			if (datapath_tb.dut.REGFILE.R3 !== expected_R3) begin
				$display(" R3 is %b, expected is %b", datapath_tb.dut.REGFILE.R3, expected_R3);
				err=1'b1;
			end
			
			if (datapath_tb.dut.REGFILE.R4 !== expected_R4) begin
				$display(" R4 is %b, expected is %b", datapath_tb.dut.REGFILE.R4, expected_R4);
				err=1'b1;
			end
			
			if (datapath_tb.dut.REGFILE.R5 !== expected_R5) begin
				$display(" R5 is %b, expected is %b", datapath_tb.dut.REGFILE.R5, expected_R5);
				err=1'b1;
			end
			
			if (datapath_tb.dut.REGFILE.R6 !== expected_R6) begin
				$display(" R6 is %b, expected is %b", datapath_tb.dut.REGFILE.R6, expected_R6);
				err=1'b1;
			end
			
			if (datapath_tb.dut.REGFILE.R7 !== expected_R7) begin
        $display(" R7 is %b, expected is %b", datapath_tb.dut.REGFILE.R7, expected_R7);
				err=1'b1;
			end
		end
	endtask
	
  initial begin //Initial block for clock wave 
		clk = 0; #5;
		forever begin
			clk=1; #5;
			clk=0; #5;
		end
	end
        
  
  initial begin //Initial block for testing
    err = 1'b0; #10;
    
    
  //Test MOV R0, #7
    sximm8=16'b111; vsel=4'b0100; writenum=3'b000; write = 1'b1; #10;
    my_checker_MOV( 16'b111, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx);
      
  //Test MOV R1, #2
    sximm8=16'b010; vsel=4'b0100; writenum=3'b001; write = 1'b1; #10;
    my_checker_MOV( 16'b111, 16'b10, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx);
     
    
  //Test ADD R2, R1, R0, LSL#1  
    readnum = 3'b000; write= 1'b0; loada = 1'b1; loadb = 1'b0; #10;	//Takes the data_out (R0) into A
    readnum = 3'b001; write= 1'b0; loada = 1'b0; loadb = 1'b1; //Takes the data_out (R1) into B
    shift = 2'b01; 	//Takes B and shifts it to the left by 1		
    asel = 1'b0; bsel = 1'b0; ALUop = 2'b00;
    loadc = 1'b1; loads = 1'b1;
    #20;
    my_checker(16'b1011, 3'b000);#10;
    vsel=4'b0001; writenum=3'b010; write = 1'b1; #10;	//Writes the value to (R2)
    my_checker_MOV( 16'b111, 16'b10, 16'b1011, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx);






  //Test MOV R0, #32767
 
    sximm8=16'b0111111111111111; vsel=4'b0100; writenum=3'b000; write = 1'b1; #10;
    my_checker_MOV( 16'b0111111111111111, 16'b10, 16'b1011, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx);
      
  //Test MOV R1, #1
    sximm8=16'b001; vsel=4'b0100; writenum=3'b001; write = 1'b1; #10;
    my_checker_MOV( 16'b0111111111111111, 16'b001, 16'b1011, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx);

 //Test ADD R2, R1, R0 Test for Negative + Overflow  
    readnum = 3'b000; write= 1'b0; loada = 1'b1; loadb = 1'b0; #10;	//Takes the data_out (R0) into A
    readnum = 3'b001; write= 1'b0; loada = 1'b0; loadb = 1'b1; //Takes the data_out (R1) into B
    shift = 2'b00; 	//Takes B and shifts it to the left by 1		
    asel = 1'b0; bsel = 1'b0; ALUop = 2'b00;
    loadc = 1'b1; loads = 1'b1;
    #20;
    my_checker(16'b1000000000000000, 3'b110);#10;
    vsel=4'b0001; writenum=3'b010; write = 1'b1; #10;	//Writes the value to (R2)
    my_checker_MOV( 16'b0111111111111111, 16'b001, 16'b1000000000000000, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx);






  //Test MOV R0, #7
    sximm8=16'b111; vsel=4'b0100; writenum=3'b000; write = 1'b1; #10;
    my_checker_MOV( 16'b111, 16'b001, 16'b1000000000000000, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx);
      
  //Test MOV R1, #2
    sximm8=16'b010; vsel=4'b0100; writenum=3'b001; write = 1'b1; #10;
    my_checker_MOV( 16'b111, 16'b10, 16'b1000000000000000, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx);
    
    
  //Test SUB, R2, R1, R0 , LSR#1
    readnum = 3'b000; write= 1'b0; loada = 1'b1; loadb = 1'b0;	#10;//Takes the data_out (R0) into A
    readnum = 3'b001; write= 1'b0; loada = 1'b0; loadb = 1'b1; //Takes the data_out (R1) into B
    shift = 2'b10; 	//Takes B and shifts it to the right by 1	
    asel = 1'b0; bsel = 1'b0; ALUop = 2'b01;
    loadc = 1'b1; loads = 1'b1;
    #20;   
    my_checker(16'b110, 3'b000);#10;
    vsel=4'b0001; writenum=3'b010; write = 1'b1; #10;	//Writes the value to (R2)
    my_checker_MOV( 16'b111, 16'b10, 16'b110, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx);






  //Test MOV R0, #1
    sximm8=16'b001; vsel=4'b0100; writenum=3'b000; write = 1'b1; #10;
    my_checker_MOV( 16'b001, 16'b10, 16'b110, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx);
      
  //Test MOV R1, #1
    sximm8=16'b001; vsel=4'b0100; writenum=3'b001; write = 1'b1; #10;
    my_checker_MOV( 16'b001, 16'b001, 16'b110, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx);


//Test SUB, R2, R1, R0 Zero flag
    readnum = 3'b000; write= 1'b0; loada = 1'b1; loadb = 1'b0;	#10;//Takes the data_out (R0) into A
    readnum = 3'b001; write= 1'b0; loada = 1'b0; loadb = 1'b1; //Takes the data_out (R1) into B
    shift = 2'b00; 	//Takes B and shifts it to the right by 1	
    asel = 1'b0; bsel = 1'b0; ALUop = 2'b01;
    loadc = 1'b1; loads = 1'b1;
    #20;   
    my_checker(16'b0, 3'b001);#10;
    vsel=4'b0001; writenum=3'b010; write = 1'b1; #10;	//Writes the value to (R2)
    my_checker_MOV( 16'b001, 16'b001, 16'b0, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx);


    
    



  //Test MOV R0, #7
    sximm8=16'b111; vsel=4'b0100; writenum=3'b000; write = 1'b1; #10;
    my_checker_MOV( 16'b111, 16'b001, 16'b0, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx);
      
  //Test MOV R1, #2
    sximm8=16'b010; vsel=4'b0100; writenum=3'b001; write = 1'b1; #10;
    my_checker_MOV( 16'b111, 16'b10, 16'b0, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx);


    //Test AND
    readnum = 3'b000; write= 1'b0; loada = 1'b1; loadb = 1'b0;	#10;//Takes the data_out (R0) into A
    readnum = 3'b001; write= 1'b0; loada = 1'b0; loadb = 1'b1; //Takes the data_out (R1) into B
    shift = 2'b00;
		
    asel = 1'b0; bsel = 1'b0; ALUop = 2'b10;
    loadc = 1'b1; loads = 1'b1;
    #20;
    my_checker(16'b10, 3'b000);#10;
    vsel=4'b0001; writenum=3'b010; write = 1'b1; #10;	//Writes the value to (R2)
    my_checker_MOV( 16'b111, 16'b10, 16'b10, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx);
    
    




    
  //Test NOT
    readnum = 3'b000; write= 1'b0; loada = 1'b1; loadb = 1'b0;	#10;//Takes the data_out (R0) into A
    readnum = 3'b001; write= 1'b0; loada = 1'b0; loadb = 1'b1; //Takes the data_out (R1) into B
    shift = 2'b00; 	//Takes B and shifts it to the left by 1
		
    asel = 1'b0; bsel = 1'b0; ALUop = 2'b11;
    loadc = 1'b1; loads = 1'b1;
    #20;
    my_checker(16'b1111111111111101, 3'b100);#10;
    vsel=4'b0001; writenum=3'b010; write = 1'b1; #10;	//Writes the value to (R2)
    my_checker_MOV( 16'b111, 16'b10, 16'b1111111111111101, 16'bx, 16'bx, 16'bx, 16'bx, 16'bx);
    
    
    
    
  //Test the 2'b11 shift operator with an addition
  //Store a value in r3
    sximm8=16'b0; vsel=4'b0100; writenum=3'b011; write = 1'b1; #10;	
    my_checker_MOV( 16'b111, 16'b10, 16'b1111111111111101, 16'b0, 16'bx, 16'bx, 16'bx, 16'bx);
      
  //Store a value in r4
    sximm8=16'b1000000000001111; vsel=4'b0100; writenum=3'b100; write = 1'b1; #10;	
    my_checker_MOV( 16'b111, 16'b10, 16'b1111111111111101, 16'b0, 16'b1000000000001111, 16'bx, 16'bx, 16'bx);
    
    readnum = 3'b011; write= 1'b0; loada = 1'b1; loadb = 1'b0;	#10;//Takes the data_out (R3) into A
    readnum = 3'b100; write= 1'b0; loada = 1'b0; loadb = 1'b1; //Takes the data_out (R4) into B
    shift = 2'b11; 	//Takes B and shifts it to the right by 1 then keeps the MSB as its prior
		
    asel = 1'b0; bsel = 1'b0; ALUop = 2'b00;	//Adds A and B
    loadc = 1'b1;
    #20;
    my_checker(16'b1100000000000111, 3'b110);#10;
    vsel=4'b0001; writenum=3'b101; write = 1'b1; #10;	//Writes the value to (R5)
    my_checker_MOV( 16'b111, 16'b10, 16'b1111111111111101, 16'b0, 16'b1000000000001111, 16'b1100000000000111, 16'bx, 16'bx);
    
    if (~err) $display("PASSED");
		else $display("FAILED");
		$stop; 
    
  end
endmodule
