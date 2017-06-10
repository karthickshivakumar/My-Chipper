//TO DO: 17:15 #1 Seperate local input from pipeline one module
//      9/6/17 #2 resolve clock conundrum 

//UPDATE 17:38 9/6/17 #Removed local injection at pipeline one 
//TO DO :#3 Remove vestiges of local injection to pipeline one in chipper module 
//	 #4 Include cachemiss module for local injection into combone

//UPDATE 21:26 9/6/17 Completed all pending to dos

//Should create testbench

module chipper (
inc,
nsig,
ssig,
esig,
wsig,
clksig,
clk,
cachemiss,
nout,
sout,
eout,
wout,
lout
);

input [6:0] inc;
input nsig;
input ssig;
input esig;
input wsig;
input clksig;
input clk;                  //To Input a clock if available onboard, otherwise create a code clock
input [9:0] cachemiss;
output [9:0] nout;
output [9:0] sout;
output [9:0] eout;
output [9:0] wout;
output [9:0] lout;

wire [6:0] inc;
wire nsig;
wire ssig;
wire esig;
wire wsig;
wire clksig;
wire clk;
wire [9:0] cachemiss;
wire [9:0] nout;   //from pdn
wire [9:0] sout;
wire [9:0] eout;
wire [9:0] wout;
wire [9:0] lout;

wire [9:0] st1n;   //from pipeline one
wire [9:0] st1s;
wire [9:0] st1e;
wire [9:0] st1w;

wire [9:0] st2n;   //from combone
wire [9:0] st2s;
wire [9:0] st2e;
wire [9:0] st2w;

wire [9:0] st3n;   //from pipeline two
wire [9:0] st3s;
wire [9:0] st3e;
wire [9:0] st3w;

wire lclk;         //to set timing for cachemiss eject module

pipeline_one U0(
.inc(inc),
.nsig(nsig),
.ssig(ssig),
.esig(esig),
.wsig(wsig),
.clksig(clksig),
.clk(clk),
.noun(st1n),
.soun(st1s),
.eoun(st1e),
.woun(st1w),
.lclk(lclk)
);

cache_miss U1(                 //needs the lclk from pipeline one
.clk(lclk),
.cachemiss(cachemiss)
);

combone U2(
.nin(st1n),
.sin(st1s),
.ein(st1e),
.win(st1w),
.lin(cachemiss),
.nout(st2n),
.sout(st2s),
.eout(st2e),
.wout(st2w),
.lout(lout)
);

pipeline_two U3(
.nty(st2n),
.sty(st2s),
.ety(st2e),
.wty(st2w),
.clk(clk),
.nxt(st3n),
.sxt(st3s),
.wxt(st3w),
.ext(st3e)
);

pdn U4(
.north_in(st3n),
.south_in(st3n),
.west_in(st3n),
.east_in(st3n),
.north_out(nout),
.south_out(sout),
.east_out(eout),
.west_out(wout)
);


endmodule
