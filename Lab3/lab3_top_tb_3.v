module lab3_top_tb_3();

	reg [3:0] KEY;	//KEY0 is the clock input	//KEY[0] is the CLK KEY[3] is the RESET
	reg [9:0] SW;	//Switch input
	reg err;	//Suggested to set things to error, makes it easier to find mistakes
	
	wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire [9:0] LEDR;
	wire [3:0] state = 4'b0000;
	reg [3:0] binary;


	lab3_top DUT(SW,state,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);

	initial begin			//Initial block to set the FSM clock and to test the rising edge
		
		KEY[0] = 0;
		#5;
		forever begin
			KEY[0] = 1; 
			#5;
			KEY[0] = 0;
			#5;
		end
	end


	initial begin

		KEY[3] = 1;
		SW[9:0] = 0;
		err = 0;
		#10;

	//Closed
	if ( lab3_top_tb_3.DUT.state == 4'b1100 ) begin
		$display ("HEX's should show %b %b %b %b %b %b. which means it's closed", ~HEX5, ~HEX4, ~HEX3, ~HEX2, ~HEX1, ~HEX0);
		err = 0;
		KEY[3] = 0;
	end

	//Open
	if ( lab3_top_tb_3.DUT.state == 4'b0110 ) begin
		$display ("HEX's should show %b %b %b %b %b %b, which means it's open", ~HEX5, ~HEX4, ~HEX3, ~HEX2, ~HEX1, ~HEX0);
		err = 0;
		KEY[3] = 0;
	end

	//If SW isn't 0
	if ( lab3_top_tb_3.DUT.SW !== 9'b0 ) begin
		$display ("HEX0 should show anything but 0 if binary isn't 4'b0, in this case it's %b", ~HEX0);
		err = 0;
		KEY[3] = 0;
	end

	//If SW is at zero
	//if ( lab3_top_tb_3.DUT.SW == 9'b0 ) begin
		//$display ("HEX0 shows %b, and we expected 0111111", ~HEX0);
		//err = 0;
		//KEY[3] = 0;
	//end

	//if ( lab3_top_tb_3.DUT.SW !== 4'bx ) begin
		//$display ("YOU HAVE AN ERROR. This is due to binary not being 0-9");
		//err = 1;
		//KEY[3] = 0;

	
	if (lab3_top_tb_3.DUT.SW == 9'b0)begin
		$display ("With switch in the zero position you are given %b, you expected 7b'0111111", ~HEX0);
	
	end


	if (lab3_top_tb_3.DUT.KEY[0] == 1)begin
		$display ( "When posedge comes around, given state, %b will transition to the next state, %b", state, (SW[9:0]==9'dx));
	end

	end

endmodule
