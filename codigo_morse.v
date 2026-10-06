module codigo_morse(
    input wire clk,
    input wire rst_n,
    output wire pwm_out
);

wire [31:0] duty_cycle;
wire [31:0] period;
wire valid;
wire ready;
wire pwm_intermediate;

fsm fsm_inst (
    .clk(clk),
    .rst_n(rst_n),
    .duty_cycle(duty_cycle),
    .period(period),
    .valid(valid),
    .ready(ready)
);

pwm pwm_inst (
    .clk(clk),
    .rst_n(rst_n),
    .duty_cycle(duty_cycle),
    .period(period),
    .ready(ready),
    .valid(valid),
    .pwm_out(pwm_intermediate)
);

assign pwm_out = ~pwm_intermediate;

endmodule