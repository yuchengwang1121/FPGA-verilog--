//sv_motor_demo1
//clock count in 20ms
`define PERIOD_NUM 999999
//2.5ms 125000 (最大較度時買)
`define MAX_NUM (('PERIOD_NUM+1)*25/200)-1
//0.5ms 25000
`define MIN_NUM (('PERIOD_NUM+1)*5/200)-1

`define ONE_DEG_NUM (`MAX_NUM-`MIN_DEG)/180

module sv_motor_demo1(//代表4個net
input clk, rst,
input [1:0] btn,
input [1:0] sw,
output pwm);

wire [7:0] deg;//度數
wire [31:0] duty_num;//換成PWM

wire rst_deb; //rst的除彈跳
wire [1:0] sw_deb//speed 的除彈跳

wire [1:0] btn_syn;//按鈕同步化

assign duty_num = (`ONE_DEG_NUM*deg)+`MIN_NUM;

assign btn_syn_n = ~btn_syn; //not

debounce deb0(//彈跳
.clk(clk),//前面為原始模組名稱，括弧放外面用什麼訊號跟這個模組連接
.bin(rst),
.bout(rst_deb));

debounce deb1(
.clk(clk),
.bin(sw[0]),
.bout(sw_deb[0]));

debounce deb2(
.clk(clk),
.bin(sw[1]),
.bout(sw_deb[1]));

sync sync1(//同步化
.clk(clk),
.rst(rst_deb),
.in(btn[0]),
.out(btn_syn[0]));

sync sync2(//同步化
.clk(clk),
.rst(rst_deb),
.in(btn[1]),
.out(btn_syn[1]));

sv_motor_ui ui1(
.clk(clk),
.rst(rst_deb),
.inc(btn_syn_n[0]),
.dec(btn_syn_n[1]),
.speed(sw),
.deg(deg));

sv_mptor_pwm pwm1(
.clk(clk),
.rst(rst_deb),
.period_num(`PERIOD_NUM),
.duty_num(duty_num),
.pwm_out(pwm));

endmodule


