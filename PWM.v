module PWM(
input  clk, rst,
input  [3:0] duty,
output reg pwm);

//reg 可變動位元得無號整數
//integer 32位元寬的有號整數
//real 雙倍精準度之有號浮點數
//time 64位元寬度的無號整數


reg [2:0] cnt;// 抽象的資料儲存物件，類似C語言的變數
wire It; //宣告一條接線，命名為It 內定預設值為z 接線:連接實體元件
assign It = ({1'b0,cnt}<duty);

always@(posedge clk or posedge rst)//數8計數器
begin
  if(rst) cnt=3'd0
  else cnt=cnt+1'd1;
end

always@(posedge clk or posedge rst)//正反器
begin
  if(rst) pwm=1'b0
  else    pwm=It;
end

endmodule   