module debounce(clk, bin, bout);
parameter CNT_W = 20; //定義為常數 可以重複使用
input     clk; //單一位元不用額外定義
input     bin;
output     bout;
reg   [CNT_W-1:0]   cnt;
reg   bin_syn0, bin_syn1, bin_int;
assign   bout=~cnt[CNT_W-1]; //MSB為1十上限 為持續指定(輸入經過運算直接將輸出連接出去) ~為取反向電路(NOT )

always@(posedge clk)//區塊內描述永無止盡 posedge代表正緣觸發(0->1)
begin//synchronizer
  bin_syn0 <= bin;// 無限制指定範例，同時給值，像是thread
  bin_syn1 <= bin_syn0;//
  bin_int  <= bin_syn1;//
end

always@(posedge clk)
begin
  if(bin_int)  cnt <= {CNT_W{1'b0}}; //1'=>8位元 b=>二進位 0=>數值 數字{位元} => 重複幾次 此為 20{1'b0}=> 0_0_0_0_0...0_0
  else if(!cnt[CNT_W-1])
           cnt<=cnt+1'b1;
end
endmodule


