module lab3_top(SW,state,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
  input [9:0] SW;
  input [3:0] KEY;
  output [3:0] state;
  output reg[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  output [9:0] LEDR; 
  reg [3:0] state=4'b0000;
  	 
	always @* begin											
		if (state==4'b1100) begin //print CLOSED
										HEX5=~7'b0111001;	
										HEX4=~7'b0111000;
										HEX3=~7'b0111111;
										HEX2=~7'b1101101;
										HEX1=~7'b1111001;
										HEX0=~7'b0111111; //D is just like O
									end
						
		else if (state==4'b0110) begin //print OPEn
										HEX5=~7'b0000000;
										HEX4=~7'b0000000;
										HEX3=~7'b0111111;
										HEX2=~7'b1110011;
										HEX1=~7'b1111001;
										HEX0=~7'b1010100;
									end
									
		else 
			case (SW[9:0])
				9'd0:	begin
							HEX0=~7'b0111111;
							HEX1=~7'b0000000;
							HEX2=~7'b0000000;
							HEX3=~7'b0000000;
							HEX4=~7'b0000000;
							HEX5=~7'b0000000;
						end
				9'd1:	begin
							HEX0=~7'b0000110;
							HEX1=~7'b0000000;
							HEX2=~7'b0000000;
							HEX3=~7'b0000000;
							HEX4=~7'b0000000;
							HEX5=~7'b0000000;
						end
				9'd2:	begin
							HEX0=~7'b1011011;
							HEX1=~7'b0000000;
							HEX2=~7'b0000000;
							HEX3=~7'b0000000;
							HEX4=~7'b0000000;
							HEX5=~7'b0000000;
						end
				9'd3: begin
							HEX0=~7'b1001111;
							HEX1=~7'b0000000;
							HEX2=~7'b0000000;
							HEX3=~7'b0000000;
							HEX4=~7'b0000000;
							HEX5=~7'b0000000;
						end
				9'd4:	begin
							HEX0=~7'b1100110;	
							HEX1=~7'b0000000;
							HEX2=~7'b0000000;
							HEX3=~7'b0000000;
							HEX4=~7'b0000000;
							HEX5=~7'b0000000;
						end				
				9'd5: begin
							HEX0=~7'b1101101;
							HEX1=~7'b0000000;
							HEX2=~7'b0000000;
							HEX3=~7'b0000000;
							HEX4=~7'b0000000;
							HEX5=~7'b0000000;
						end
				9'd6: begin 
							HEX0=~7'b1111101;
							HEX1=~7'b0000000;
							HEX2=~7'b0000000;
							HEX3=~7'b0000000;
							HEX4=~7'b0000000;
							HEX5=~7'b0000000;
						end
				9'd7:	begin
							HEX0=~7'b0000111;
							HEX1=~7'b0000000;
							HEX2=~7'b0000000;
							HEX3=~7'b0000000;
							HEX4=~7'b0000000;
							HEX5=~7'b0000000;
						end
				9'd8: begin	
							HEX0=~7'b1111111;
							HEX1=~7'b0000000;
							HEX2=~7'b0000000;
							HEX3=~7'b0000000;
							HEX4=~7'b0000000;
							HEX5=~7'b0000000;
						end
				9'd9: begin 
							HEX0=~7'b1101111;
							HEX1=~7'b0000000;
							HEX2=~7'b0000000;
							HEX3=~7'b0000000;
							HEX4=~7'b0000000;
							HEX5=~7'b0000000;
						end
				default: begin //print ErrOr
						HEX5=~7'b0000000;
						HEX4=~7'b1111001;
						HEX3=~7'b1010000;
						HEX2=~7'b1010000;
						HEX1=~7'b0111111;
						HEX0=~7'b1010000;
							end
			endcase
	end
		  
  always @(posedge ~KEY[0]) begin
		if (~KEY[3])
			state=4'b0000;
		else begin
			case (state) 
				4'b0000:state=(SW[9:0]==9'd2)?4'b0001:4'b0111;//beginning state
				4'b0001:state=(SW[9:0]==9'd3)?4'b0010:4'b1000;//true1
				4'b0010:state=(SW[9:0]==9'd6)?4'b0011:4'b1001;//true2
				4'b0011:state=(SW[9:0]==9'd7)?4'b0100:4'b1010;//true3
				4'b0100:state=(SW[9:0]==9'd9)?4'b0101:4'b1011;//true4
				4'b0101:state=(SW[9:0]==9'd8)?4'b0110:4'b1100;//true5
				4'b0110:state=4'b0110;//true6
				4'b0111:state=4'b1000;//false1
				4'b1000:state=4'b1001;//false2
				4'b1001:state=4'b1010;//false3
				4'b1010:state=4'b1011;//false4
				4'b1011:state=4'b1100;//false5
				4'b1100:state=4'b1100;//false6
				default:state=4'bxxxx;
			endcase						
		end
	end				
endmodule




	