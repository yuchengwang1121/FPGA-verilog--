module sync(clk, rst, in ,out);
input rst,clk;
input in;
output reg out;
reg in_syn0 , in_syn1;

always@(posedge clk)
begin
	in_syn0 <=#1 in; in_syn1 <=#1 in_syn0;
	out <=#1 in_syn1;
end
end module