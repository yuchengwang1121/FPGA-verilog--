//sv_motor_ui
`define DEG_STEP 8'd1 //一次讓角度上升幾度(1。)
`define MAX_DEG 8'd180 // 最大180度
`define MIN_DEG 8'd0 //最小0度

module sv_motor_ui(
input clk,rst, // 時脈，重製
input inc,dec, //計數器1(上述下數)
input [1:0]speed,
output reg [7:0] deg);

reg [21:0] cnt;//描述計數器2(speed) 22bit 暫存器 ，用來當作除頻器

always@(posedge clk or posedge rst)//計數器1
begin
  if(rst) deg<=#1 8'd90 //如果按下rst 回90度 8'=>8位元 d=>十進位 90=>數值
  else casex({inc, dec})//優先編碼 new = inc[0]_dec[0]
       2'b1x:if(cnt[21]&(deg!='MAX_DEG))//當inc[1]=2'b1x(只看高位元 低的=x => 忽略), 當[21] = 1(可上數), &為簡化的AND
                deg<=#1 deg+'DEG_STEP;//每次加一個角度 #1 => 延遲一個時間單位
       2'b01:if(cnt[21]&(deg!='MIN_DEG))//當inc[1]=2'b01, 21接線位置 &為簡化的AND
                deg<=#1 deg-'DEG_STEP;//每次減一個角度
       endcase
end

always@(posedge clk or posedge rst)
begin
  if(rst) cnt<=#1 22'd0;
  else if(cnt[21])//上述後歸零
          cnt<=#1 22'd0;//歸零
  else if(~(inc|dec))//沒有角度變化
          cnt<=#1 22'd0;//歸零
  else    cnt=#1 cnt+speed+1'd1;
end 
end module