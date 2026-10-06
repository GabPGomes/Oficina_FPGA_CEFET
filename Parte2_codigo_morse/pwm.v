module pwm
(
    input wire clk,
    input wire rst_n,

    input wire [31:0] duty_cycle, // number of active clock cycles in a period
    input wire [31:0] period,     // number of clock cycles in a period

    output reg ready,             // module is ready to accept new values
    input wire valid,             // FSM has valid duty_cycle and period values

    output wire pwm_out
);

reg [31:0] counter;
reg [31:0] current_duty_cycle;
reg [31:0] current_period;
reg counter_enable;


// Control logic
always @(posedge clk or negedge rst_n) begin

    if (!rst_n) begin
        counter_enable     <= 1'b0;
        ready              <= 1'b1;
        current_duty_cycle <= 32'd0;
        current_period     <= 32'd0;
    end else begin

        // Accept a new period
        if (valid && ready) begin
            current_duty_cycle <= duty_cycle;
            current_period     <= period;
            ready              <= 1'b0;
            counter_enable     <= 1'b1;
        end

        // Wait until the current period is complete
        else if (counter_enable) begin
            if (current_period == 32'd0 ||
                counter >= current_period - 1'b1) begin

                counter_enable <= 1'b0;
                ready           <= 1'b1;
            end
        end

    end
end


// Counter logic
always @(posedge clk or negedge rst_n) begin

    if (!rst_n) begin
    end else begin

        if (counter_enable) begin
            if () begin
            end
        end else begin
        end

    end
end


// PWM output
assign pwm_out = ;

endmodule
