module dmaMemory
(
	input clockA, clockB,  writeEnableA, writeEnableB, 
  	input [8:0] addressA, addressB,
	input [31:0] dataInA,dataInB,
	output reg [31:0] dataOutA, dataOutB
);
	// Declare the RAM variable
	reg [31:0] ram[511:0];
	
	// Port A
	always @ (posedge clockA)
	begin
		if (writeEnableA) 
		begin
			ram[addressA] <= dataInA;
			dataOutA <= dataInA;
		end
		else 
		begin
			dataOutA <= ram[addressA];
		end
	end
	
	// Port B
	always @ (posedge clockB)
	begin
		if (writeEnableB)
		begin
			ram[addressB] <= dataInB;
			dataOutB <= dataInB;
		end
		else 
		begin
			dataOutB <= ram[addressB];
		end
	end
	
endmodule