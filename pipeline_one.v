module pipeline_one(
inc,
nsig,
ssig,
esig,
wsig,
lsig,
clksig,
noun,
soun,
eoun,
woun,
loun
);

input [6:0] inc;
input nsig;
input ssig;
input esig;
input wsig;
input lsig;
input clksig;
output [9:0] noun;
output [9:0] soun;
output [9:0] eoun;
output [9:0] woun;
output [9:0] loun;

wire [6:0] inc;
wire nsig;
wire ssig;
wire esig;
wire wsig;
wire lsig;
reg [9:0] noun;
reg [9:0] soun;
reg [9:0] eoun;
reg [9:0] woun;
reg [9:0] loun;

reg [6:0] pipeline [0:24];
reg clk;
integer i;
integer j;
integer k;
integer setk;

initial begin
i = 0;
k = 0; 
setk = 0;
noun [8:6] = 3'b000;
soun [8:6] = 3'b000;
eoun [8:6] = 3'b000;
woun [8:6] = 3'b000;
loun [8:6] = 3'b000;
end

always begin
#5.5 clk = ~clk;
end

always @ (posedge clksig) begin
 clk = 1;
end

always @ (nsig or ssig or esig or wsig) begin

	if ( i < 21 ) begin
	if (nsig === 1) begin
		pipeline [i] = inc;
	end else if (ssig === 1) begin
		pipeline [i+1] = inc;
	end else if (esig === 1) begin
		pipeline [i+2] = inc;
	end else if (wsig === 1) begin
		pipeline [i+3] = inc;
	end else if (lsig === 1) begin
		pipeline [i+4] = inc;
	end
	k = k+1;
	if (k === 6) begin 
	i = i+5;
	k = 1;
	end
	end
end	

always @ (posedge clk) begin
	{noun[9],noun[5:0]} = pipeline [0]; 
	{soun[9],soun[5:0]} = pipeline [1]; 
	{eoun[9],eoun[5:0]} = pipeline [2]; 
	{woun[9],woun[5:0]} = pipeline [3];
	{loun[9],loun[5:0]} = pipeline [4];
	for(j = 0; j<20 ; j = j+1) begin
            pipeline [j] = pipeline [j+5];
	end
	if(i !== 0)
	i = i-5;
end	

combone U0(
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
);

endmodule