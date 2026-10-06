`timescale 1ns/1ps
module codigo_morse_tb;

    // Inputs
    reg rst_n;
    reg clk;

    codigo_morse dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    always #10 clk = ~clk; // Clock generation 50 MHz
    initial begin
            // Initialize Inputs
            clk = 0;
            rst_n = 0;

            // Wait for global reset to finish
            #100;
            rst_n = 1;

            #5000;
            $finish;

    end

endmodule
