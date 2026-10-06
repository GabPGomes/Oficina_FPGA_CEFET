module fsm #(
    parameter integer CLOCK_FREQ_HZ = 50_000_000,
    parameter integer WPM            = 5
)(
    input wire clk,
    input wire rst_n,
    output reg [31:0] duty_cycle,
    output reg [31:0] period,
    output reg valid,
    input wire ready
);

localparam [2:0]
    WAIT         = 3'b000,
    SHORT_PULSE  = 3'b001,
    LONG_PULSE   = 3'b010,
    SYMBOL_SPACE = 3'b011,
    LETTER_SPACE = 3'b100,
    WORD_SPACE   = 3'b101;

// Morse timing:
// Dot          = 1 unit
// Dash         = 3 units
// Symbol space = 1 unit
// Letter space = 3 units
// Word space   = 7 units

// A Morse dot lasts 1.2 / WPM seconds.
localparam integer UNIT_CYCLES = (CLOCK_FREQ_HZ * 6) / (WPM * 5);

reg [2:0] state;
reg [2:0] next_state;

reg [7:0] symbol_counter;
reg [7:0] next_symbol_counter;


// State and counter registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state          <= WAIT;
        symbol_counter <= 8'd0;
    end else begin
        state          <= next_state;
        symbol_counter <= next_symbol_counter;
    end
end


// Next-state and output logic
always @(*) begin

    // Default values
    next_state          = state;
    next_symbol_counter = symbol_counter;

    duty_cycle = 32'd0;
    period     = 32'd0;
    valid      = 1'b0;

    case (state)

        WAIT: begin

            if (ready) begin

                case (symbol_counter)

                    // F = ..-.
                    8'd0:  next_state = SHORT_PULSE;
                    8'd1:  next_state = SYMBOL_SPACE;
                    8'd2:  next_state = SHORT_PULSE;
                    8'd3:  next_state = SYMBOL_SPACE;
                    8'd4:  next_state = LONG_PULSE;
                    8'd5:  next_state = SYMBOL_SPACE;
                    8'd6:  next_state = SHORT_PULSE;
                    8'd7:  next_state = LETTER_SPACE;

                    // P = .--.
                    8'd8:  next_state = SHORT_PULSE;
                    8'd9:  next_state = SYMBOL_SPACE;
                    8'd10: next_state = LONG_PULSE;
                    8'd11: next_state = SYMBOL_SPACE;
                    8'd12: next_state = LONG_PULSE;
                    8'd13: next_state = SYMBOL_SPACE;
                    8'd14: next_state = SHORT_PULSE;
                    8'd15: next_state = LETTER_SPACE;

                    // G = --.
                    8'd16: next_state = LONG_PULSE;
                    8'd17: next_state = SYMBOL_SPACE;
                    8'd18: next_state = LONG_PULSE;
                    8'd19: next_state = SYMBOL_SPACE;
                    8'd20: next_state = SHORT_PULSE;
                    8'd21: next_state = LETTER_SPACE;

                    // A = .-
                    8'd22: next_state = SHORT_PULSE;
                    8'd23: next_state = SYMBOL_SPACE;
                    8'd24: next_state = LONG_PULSE;
                    8'd25: next_state = LETTER_SPACE;

                    // End of transmission
                    8'd26: next_state = WORD_SPACE;

                    default: begin
                        next_state          = WAIT;
                        next_symbol_counter = 8'd0;
                    end

                endcase

            end

        end


        // Dot: 1 Morse unit
        SHORT_PULSE: begin
            duty_cycle          = UNIT_CYCLES;
            period              = UNIT_CYCLES;
            valid               = 1'b1;
            next_state          = WAIT;
            next_symbol_counter = symbol_counter + 1'b1;
        end


        // Dash: 3 Morse units
        LONG_PULSE: begin
            duty_cycle          = 3 * UNIT_CYCLES;
            period              = 3 * UNIT_CYCLES;
            valid               = 1'b1;
            next_state          = WAIT;
            next_symbol_counter = symbol_counter + 1'b1;
        end


        // Space between symbols: 1 Morse unit
        SYMBOL_SPACE: begin
            duty_cycle          = 16'd0;
            period              = UNIT_CYCLES;
            valid               = 1'b1;
            next_state          = WAIT;
            next_symbol_counter = symbol_counter + 1'b1;
        end


        // Space between letters: 3 Morse units
        LETTER_SPACE: begin
            duty_cycle          = 16'd0;
            period              = 3 * UNIT_CYCLES;
            valid               = 1'b1;
            next_state          = WAIT;
            next_symbol_counter = symbol_counter + 1'b1;
        end


        // Space between words: 7 Morse units
        WORD_SPACE: begin
            duty_cycle          = 16'd0;
            period              = 7 * UNIT_CYCLES;
            valid               = 1'b1;
            next_state          = WAIT;
            next_symbol_counter = 8'd0;
        end


        default: begin
            next_state          = WAIT;
            next_symbol_counter = 8'd0;
        end

    endcase
end

endmodule