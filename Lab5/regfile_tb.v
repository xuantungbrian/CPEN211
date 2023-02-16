module regfile_tb;
	reg write,  clk, err;
	reg [2:0] readnum, writenum;
	reg [15:0] data_in;
	wire [15:0] data_out;
	
	regfile DUT(data_in, writenum, write, readnum, clk, data_out);
		
	task my_checker_write;
		input [15:0] expected_R0;
		input [15:0] expected_R1;
		input [15:0] expected_R2;
		input [15:0] expected_R3;
		input [15:0] expected_R4;
		input [15:0] expected_R5;
		input [15:0] expected_R6;
		input [15:0] expected_R7;
		
		begin			
			if (regfile_tb.DUT.R0 !== expected_R0) begin
				$display(" R0 is %b, expected is %b", regfile_tb.DUT.R0, expected_R0);
				err=1'b1;
			end

			if (regfile_tb.DUT.R1 !== expected_R1) begin
				$display(" R1 is %b, expected is %b", regfile_tb.DUT.R1, expected_R1);
				err=1'b1;
			end
	
			if (regfile_tb.DUT.R2 !== expected_R2) begin
				$display(" R2 is %b, expected is %b", regfile_tb.DUT.R2, expected_R2);
				err=1'b1;
			end
			
			if (regfile_tb.DUT.R3 !== expected_R3) begin
				$display(" R3 is %b, expected is %b", regfile_tb.DUT.R3, expected_R3);
				err=1'b1;
			end
			
			if (regfile_tb.DUT.R4 !== expected_R4) begin
				$display(" R4 is %b, expected is %b", regfile_tb.DUT.R4, expected_R4);
				err=1'b1;
			end
			
			if (regfile_tb.DUT.R5 !== expected_R5) begin
				$display(" R5 is %b, expected is %b", regfile_tb.DUT.R5, expected_R5);
				err=1'b1;
			end
			
			if (regfile_tb.DUT.R6 !== expected_R6) begin
				$display(" R6 is %b, expected is %b", regfile_tb.DUT.R6, expected_R6);
				err=1'b1;
			end
			
			if (regfile_tb.DUT.R7 !== expected_R7) begin
				$display(" R7 is %b, expected is %b", regfile_tb.DUT.R7, expected_R7);
				err=1'b1;
			end
		end
	endtask
	
	
	task my_checker_read;
		input [15:0] expected_read;
		
		begin
			if (regfile_tb.DUT.data_out !== expected_read) begin
					$display(" Output read is %b, expected is %b", regfile_tb.DUT.data_out, expected_read);
					err=1'b1;
			end
		end
	endtask
	
	
	initial begin
		clk = 0; #5;
		forever begin
			clk=1; #5;
			clk=0; #5;
		end
	end
	
	
	initial begin
		err=1'b0; #10;
		
		//check write!=1, R3=42, may not need this
		
		//Check write in R0=31
		data_in=16'b0000000000011111; writenum=3'b000; write=1'b1; #10;
		my_checker_write(16'b0000000000011111, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx);
		
		//Check write in R1=102
		data_in=16'b0000000001100110; writenum=3'b001; write=1'b1; #10;
		my_checker_write(16'b0000000000011111, 16'b0000000001100110, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx);
		
		//Check write in R2=56
		data_in=16'b0000000000111000; writenum=3'b010; write=1'b1; #10;
		my_checker_write(16'b0000000000011111, 16'b0000000001100110, 16'b0000000000111000, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx);
		
		//Check write in R3=42
		data_in=16'b0000000000101010; writenum=3'b011; write=1'b1; #10;
		my_checker_write(16'b0000000000011111, 16'b0000000001100110, 16'b0000000000111000, 16'b0000000000101010, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx);
		
		
		//Check write in R4=78
		data_in=16'b0000000001001110; writenum=3'b100; write=1'b1; #10;
		my_checker_write(16'b0000000000011111, 16'b0000000001100110, 16'b0000000000111000, 16'b0000000000101010, 16'b0000000001001110, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx);
		
		
		
		//Check write in R5=498
		data_in=16'b0000000111110010; writenum=3'b101; write=1'b1; #10;
		my_checker_write(16'b0000000000011111, 16'b0000000001100110, 16'b0000000000111000, 16'b0000000000101010, 16'b0000000001001110, 16'b0000000111110010, 16'bxxxxxxxxxxxxxxxx, 16'bxxxxxxxxxxxxxxxx);
		
		
		//Check write in R6=785
		data_in=16'b0000001100010001; writenum=3'b110; write=1'b1; #10;
		my_checker_write(16'b0000000000011111, 16'b0000000001100110, 16'b0000000000111000, 16'b0000000000101010, 16'b0000000001001110, 16'b0000000111110010, 16'b0000001100010001, 16'bxxxxxxxxxxxxxxxx);
		
		
		//Check write in R7=1001
		data_in=16'b0000001111101001; writenum=3'b111; write=1'b1; #10;
		my_checker_write(16'b0000000000011111, 16'b0000000001100110, 16'b0000000000111000, 16'b0000000000101010, 16'b0000000001001110, 16'b0000000111110010, 16'b0000001100010001, 16'b0000001111101001);
		
		
		//Check read in R0
		write=1'b0; readnum=3'b000; #5; 
		my_checker_read(16'b0000000000011111);
		#10;
		
		//Check read in R1
		write=1'b0; readnum=3'b001; #5;
		my_checker_read(16'b0000000001100110);
		#10;
		
		//Check read in R2
		write=1'b0; readnum=3'b010; #5; 
		my_checker_read(16'b0000000000111000);
		#10;
		
		//Check read in R3
		write=1'b0; readnum=3'b011; #5;
		my_checker_read(16'b0000000000101010);
		#10;
		
		//Check read in R4
		write=1'b0; readnum=3'b100; #5;
		my_checker_read(16'b0000000001001110);
		#10;
		
		//Check read in R5
		write=1'b0; readnum=3'b101; #5;
		my_checker_read(16'b0000000111110010);
		#10;
		
		//Check read in R6
		write=1'b0; readnum=3'b110; #5;
		my_checker_read(16'b0000001100010001);
		#10;
		
		//Check read in R7
		write=1'b0; readnum=3'b111; #5;
		my_checker_read(16'b0000001111101001);
		#10;
		#500;
		
		
		if (~err) $display("PASSED");
		else $display("FAILED");
		$stop;
	end
endmodule
	
			
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	