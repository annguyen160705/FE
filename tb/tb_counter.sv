
`timescale 1ns/1ps

module tb_counter;

    // 1. Testbench signals
    logic clk;
    logic rst;
    logic [3:0] count;

    logic [3:0] expected_count;
    integer i;

    // 2. DUT instantiation
    counter dut (
        .clk   (clk),
        .rst   (rst),
        .count (count)
    );

    // 3. Clock generation: T = 10 ns
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // 4. Test sequence
    initial begin
        rst = 1'b0;
        expected_count = 4'd0;

        // Waveform
        $dumpfile("build/waves/counter.vcd");
        $dumpvars(0, tb_counter);

        $display("===== START SIMULATION =====");

        // TC1: Asynchronous Reset
        #2 rst = 1'b1;
        #1;

        if (count !== 4'd0)
            $fatal(1, "TC1 FAIL: Reset");
        else
            $display("TC1 PASS: Reset");

        @(negedge clk);
        rst = 1'b0;

        // TC2: Counting 0 -> 15
        // TC3: Overflow 15 -> 0
        for (i = 1; i <= 16; i = i + 1) begin
            @(posedge clk);
            #1;

            expected_count = expected_count + 4'd1;

            if (count !== expected_count) begin
                $fatal(1,
                    "FAIL: Expected=%0d, Got=%0d",
                    expected_count, count);
            end

            $display(
                "Time=%0t | Count=%0d | Expected=%0d",
                $time, count, expected_count
            );
        end

        $display("TC2 PASS: Counting");
        $display("TC3 PASS: Overflow");

        // TC4: Reset during counting
        #2 rst = 1'b1;
        #1;

        if (count !== 4'd0)
            $fatal(1, "TC4 FAIL: Async Reset");
        else
            $display("TC4 PASS: Async Reset");

        @(negedge clk);
        rst = 1'b0;

        // TC5: Counting after reset
        @(posedge clk);
        #1;

        if (count !== 4'd1)
            $fatal(1, "TC5 FAIL: Count after Reset");
        else
            $display("TC5 PASS: Count after Reset");

        $display("============================");
        $display("ALL TESTS PASSED");
        $display("============================");

        $finish;
    end

endmodule
