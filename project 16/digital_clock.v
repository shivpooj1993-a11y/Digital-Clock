`timescale 1ns/1ps

module digital_clock #(
    parameter CLK_FREQ = 10
)(
    input  wire       clk,
    input  wire       reset,

    output reg [4:0]  hours,
    output reg [5:0]  minutes,
    output reg [5:0]  seconds
);

    // Clock divider counter
    reg [31:0] clk_count;

    always @(posedge clk) begin

        if (reset) begin
            clk_count <= 32'd0;
            hours     <= 5'd0;
            minutes   <= 6'd0;
            seconds   <= 6'd0;
        end

        else begin

            // Generate one-second tick
            if (clk_count == CLK_FREQ - 1) begin

                clk_count <= 32'd0;

                // Seconds
                if (seconds == 6'd59) begin
                    seconds <= 6'd0;

                    // Minutes
                    if (minutes == 6'd59) begin
                        minutes <= 6'd0;

                        // Hours
                        if (hours == 5'd23) begin
                            hours <= 5'd0;
                        end
                        else begin
                            hours <= hours + 1'b1;
                        end

                    end
                    else begin
                        minutes <= minutes + 1'b1;
                    end

                end
                else begin
                    seconds <= seconds + 1'b1;
                end

            end
            else begin
                clk_count <= clk_count + 1'b1;
            end

        end
    end

endmodule
