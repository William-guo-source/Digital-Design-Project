`timescale 1ns/10ps

module DC_motor_tb;

reg clk = 0;
wire pwm;
reg key0, key1;
wire [6:0] seg0, seg1, seg2;

DC_motor UUT(
    .clk_50M(clk),
    .key0(key0),
    .key1(key1),
    .pwm_out(pwm),
    .seg0(seg0),
    .seg1(seg1),
    .seg2(seg2)
);

// 50 MHz clock generation
always #10 clk = ~clk;

// 強制 cnt = 128，用來測試 50% PWM
initial begin
    force UUT.cnt = 8'd128; // 這樣設置 pwm 在 50% duty cycle

    // 設定 key0 和 key1 來模擬按鈕操作（保持按鈕狀態）
    key0 = 1'b1;  // 不按下 key0
    key1 = 1'b1;  // 不按下 key1

    // 讓模擬運行一段時間，足夠看到 PWM 波形
    #50000000;    // 50ms，足夠時間看到 PWM 波形

    $stop; // 模擬結束
end

endmodule