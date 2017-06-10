//UPDATE : removed local address injection

module pipeline_one(
inc,
nsig,
ssig,
esig,
wsig,
//lsig,
clksig,
clk,
noun,
soun,
eoun,
woun,
lclk
//loun
);

input [6:0] inc;
input nsig;
input ssig;
input esig;
input wsig;
//input lsig;
input clksig;
input clk;
output [9:0] noun;
output [9:0] soun;
output [9:0] eoun;
output [9:0] woun;
output lclk;
//output [9:0] loun;

wire [6:0] inc;
wire nsig;
wire ssig;
wire esig;
wire wsig;
//wire lsig;
wire clksig;
wire clk;
reg [9:0] noun;
reg [9:0] soun;
reg [9:0] eoun;
reg [9:0] woun;
//reg [9:0] loun;

reg lclk;
reg [6:0] pipeline [0:19];
integer i;
integer j;
integer k;
integer initclk;

initial begin
i = 0;
k = 1;
initclk = 0; 
noun [8:6] = 3'b000;
soun [8:6] = 3'b000;
eoun [8:6] = 3'b000;
woun [8:6] = 3'b000;
//loun [8:6] = 3'b000;
end

/*always @ (posedge clksig) begin   //clock to be taken to main module (take input from main module but use a 
if(initclk === 0) begin
	clk = ~clk;
	initclk = 1;
end else
	#5.5 clk = ~clk;                  //local clock register which takes main clock value only at 'clocksig' input
end*/
//PROBLEM :with above green code clock is not alternating
//Only work around is to initialise local clock with clksig trigger  

always @ (posedge clksig or clk)begin
	if(clksig === 1) begin      //initclk is second in deputy of clksig and permits
		lclk = clk;         //lclk to take value of clk when clksig not available
		initclk = 1;
	end
	else if(initclk === 1)
		lclk = clk;
end

always @ (nsig or ssig or esig or wsig or lclk) begin

	if ( i < 21 && (nsig === 1 || ssig === 1 || esig === 1 || wsig === 1 /*|| lsig === 1) */)) begin
		if (nsig === 1) begin
			pipeline [i] = inc;
		end else if (ssig === 1) begin
			pipeline [i+1] = inc;
		end else if (esig === 1) begin
			pipeline [i+2] = inc;
		end else if (wsig === 1) begin
			pipeline [i+3] = inc;
		/*end else if (lsig === 1) begin
			pipeline [i+4] = inc;*/
		end
		k = k+1; 
		/*if (k === 6) begin 
		i = i+5;
		k = 1;*/
		if (k === 5) begin 
		i = i+4;
		k = 1;
		end
	end
	if ( lclk === 1) begin
		{noun[9],noun[5:0]} = pipeline [0]; 
		{soun[9],soun[5:0]} = pipeline [1]; 
		{eoun[9],eoun[5:0]} = pipeline [2]; 
		{woun[9],woun[5:0]} = pipeline [3];
	      /*{loun[9],loun[5:0]} = pipeline [4];
		for(j = 0; j<20 ; j = j+1) begin          
   			pipeline [j] = pipeline [j+5];
		end
		if(i !== 0)
		i = i-5;*/
		for(j = 0; j<16 ; j = j+1) begin          
   			pipeline [j] = pipeline [j+4];
		end
		if(i !== 0)
		i = i-4;
	end
end	

/*
always @ (posedge clk) begin
        {noun[9],noun[5:0]} = pipeline [0]; 
	{soun[9],soun[5:0]} = pipeline [1]; 
	{eoun[9],eoun[5:0]} = pipeline [2]; 
	{woun[9],woun[5:0]} = pipeline [3];
	{loun[9],loun[5:0]} = pipeline [4];
	for(j = 0; j<20 ; j = j+1) begin          //cannot drive same signal in multiple blocks
            pipeline [j] = pipeline [j+5];
	end
	if(i !== 0)
	i = i-5;
end	
*/

/*combone U0(
.nin(noun),
.sin(soun),
.ein(eoun),
.win(woun),
.lin(loun),
.nout(),
.sout(),
.eout(),
.wout(),
.lout()
);*/

endmodule