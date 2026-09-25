`timescale 1ns/1ps

module digital_clock_tb;

    // Testbench signals
    reg clk;
    reg reset;

    wire [4:0] hours;
    wire [5:0] minutes;
    wire [5:0] seconds;

    // Instantiate Digital Clock
    digital_clock #(
        .CLK_FREQ(2)
    ) uut (
        .clk(clk),
        .reset(reset),
        .hours(hours),
        .minutes(minutes),
        .seconds(seconds)
    );

    // Clock generation
    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    // Monitor outputs
    initial begin
        $monitor(
            "Time = %0t ns | Reset = %b | %02d:%02d:%02d",
            $time,
            reset,
            hours,
            minutes,
            seconds
        );
    end

    // Waveform generation
    initial begin
        $dumpfile("digital_clock.vcd");
        $dumpvars(0, digital_clock_tb);
    end

    // Test sequence
    initial begin

        // Initial reset
        reset = 1'b1;

        #20;

        reset = 1'b0;

        // Allow normal counting
        #100;

        // ------------------------------------------------
        // Test 1: Seconds rollover
        // ------------------------------------------------

        uut.hours   = 5'd0;
        uut.minutes = 6'd0;
        uut.seconds = 6'd59;
        uut.clk_count = 32'd1;

        #10;

        if (hours == 0 && minutes == 1 && seconds == 0)
            $display("TEST 1 PASSED: Seconds rollover");
        else
            $display("TEST 1 FAILED: Seconds rollover");

        // ------------------------------------------------
        // Test 2: Minutes rollover
        // ------------------------------------------------

        uut.hours   = 5'd0;
        uut.minutes = 6'd59;
        uut.seconds = 6'd59;
        uut.clk_count = 32'd1;

        #10;

        if (hours == 1 && minutes == 0 && seconds == 0)
            $display("TEST 2 PASSED: Minutes rollover");
        else
            $display("TEST 2 FAILED: Minutes rollover");

        // ------------------------------------------------
        // Test 3: 24-hour rollover
        // ------------------------------------------------

        uut.hours   = 5'd23;
        uut.minutes = 6'd59;
        uut.seconds = 6'd59;
        uut.clk_count = 32'd1;

        #10;

        if (hours == 0 && minutes == 0 && seconds == 0)
            $display("TEST 3 PASSED: 24-hour rollover");
        else
            $display("TEST 3 FAILED: 24-hour rollover");

        // ------------------------------------------------
        // End simulation
        // ------------------------------------------------

        #20;

        $display("----------------------------------");
        $display("Digital Clock Simulation Complete");
        $display("----------------------------------");

        $finish;

    end

endmodule
