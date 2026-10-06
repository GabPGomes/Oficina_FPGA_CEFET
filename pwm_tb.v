`timescale 1ns/1ps
module pwm_tb();

reg clk = 1'b0;
always #5 clk = ~clk;

reg rst_n;
reg [15:0] duty_cycle;
reg [15:0] period;

pwm pwm_inst(
    .clk(clk),
    .rst_n(rst_n),
    .duty_cycle(duty_cycle),
    .period(period),
    .ready(),
    .valid(1'b1),
    .pwm_out()
);

//Start the simulation
initial begin
    rst_n = 1'b0;
    duty_cycle = 16'd30;
    period = 16'd60;
    #50
    rst_n = 1'b1;
    #500
    duty_cycle = 16'd70;
    period = 16'd140;
    #1000
    $finish;
end

endmodule