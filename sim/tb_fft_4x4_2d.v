`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2025 01:18:44 AM
// Design Name: 
// Module Name: tb_fft_4x4_2d
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_fft_4x4_2d;

    // Testbench signals
    reg clk;
    reg reset;
    reg start;
    reg [15:0] din_real_0, din_real_1, din_real_2, din_real_3;

    // Outputs from the DUT
    wire [15:0] dout_real_0, dout_real_1, dout_real_2, dout_real_3;
    wire [15:0] dout_real_4, dout_real_5, dout_real_6, dout_real_7;
    wire [15:0] dout_real_8, dout_real_9, dout_real_10, dout_real_11;
    wire [15:0] dout_real_12, dout_real_13, dout_real_14, dout_real_15;
    wire [15:0] dout_imag_0, dout_imag_1, dout_imag_2, dout_imag_3;
    wire [15:0] dout_imag_4, dout_imag_5, dout_imag_6, dout_imag_7;
    wire [15:0] dout_imag_8, dout_imag_9, dout_imag_10, dout_imag_11;
    wire [15:0] dout_imag_12, dout_imag_13, dout_imag_14, dout_imag_15;
    wire done;

    // Instantiate the DUT (Device Under Test)
    fft_4x4_2d DUT (
        .clk(clk),
        .reset(reset),
        .start(start),
        .din_real_0(din_real_0),
        .din_real_1(din_real_1),
        .din_real_2(din_real_2),
        .din_real_3(din_real_3),
        .dout_real_0(dout_real_0), .dout_real_1(dout_real_1), .dout_real_2(dout_real_2), .dout_real_3(dout_real_3),
        .dout_real_4(dout_real_4), .dout_real_5(dout_real_5), .dout_real_6(dout_real_6), .dout_real_7(dout_real_7),
        .dout_real_8(dout_real_8), .dout_real_9(dout_real_9), .dout_real_10(dout_real_10), .dout_real_11(dout_real_11),
        .dout_real_12(dout_real_12), .dout_real_13(dout_real_13), .dout_real_14(dout_real_14), .dout_real_15(dout_real_15),
        .dout_imag_0(dout_imag_0), .dout_imag_1(dout_imag_1), .dout_imag_2(dout_imag_2), .dout_imag_3(dout_imag_3),
        .dout_imag_4(dout_imag_4), .dout_imag_5(dout_imag_5), .dout_imag_6(dout_imag_6), .dout_imag_7(dout_imag_7),
        .dout_imag_8(dout_imag_8), .dout_imag_9(dout_imag_9), .dout_imag_10(dout_imag_10), .dout_imag_11(dout_imag_11),
        .dout_imag_12(dout_imag_12), .dout_imag_13(dout_imag_13), .dout_imag_14(dout_imag_14), .dout_imag_15(dout_imag_15),
        .done(done)
    );

    // Clock generation
    localparam CLK_PERIOD = 10; // Time units for one clock period
    always begin
        #(CLK_PERIOD/2) clk = ~clk;
    end

    // Stimulus generation
    initial begin
        // Initialize signals
        clk = 1'b0;
        reset = 1'b1;
        start = 1'b0;
        din_real_0 = 16'h0000; din_real_1 = 16'h0000; din_real_2 = 16'h0000; din_real_3 = 16'h0000;

        //1. Apply reset
        #(CLK_PERIOD) reset = 1'b0;

        //2. Wait for a moment
        //@(posedge clk);

        //3. Start the FFT process
        start = 1'b1;
        @(posedge clk);
        start = 1'b0;

        //4. Apply input data sequentially
        // CU asserts enable_block1 in state INPUT1 (after seeing start)
        // DU loads data for block 1 when enable_block1 is high.
        din_real_0 = 16'd1; din_real_1 = 16'd2; din_real_2 = 16'd3; din_real_3 = 16'd4;
        $display("[%0t] TB: Applied data for Block 1 (during CU state INPUT1): %d, %d, %d, %d", $time, din_real_0, din_real_1, din_real_2, din_real_3);
        @(posedge clk); // CU moves to INPUT2, asserts enable_block2

        din_real_0 = 16'd5; din_real_1 = 16'd6; din_real_2 = 16'd7; din_real_3 = 16'd8;
        $display("[%0t] TB: Applied data for Block 2 (during CU state INPUT2): %d, %d, %d, %d", $time, din_real_0, din_real_1, din_real_2, din_real_3);
        @(posedge clk); // CU moves to INPUT3, asserts enable_block3

        din_real_0 = 16'd9; din_real_1 = 16'd10; din_real_2 = 16'd11; din_real_3 = 16'd12;
        $display("[%0t] TB: Applied data for Block 3 (during CU state INPUT3): %d, %d, %d, %d", $time, din_real_0, din_real_1, din_real_2, din_real_3);
        @(posedge clk); // CU moves to INPUT4, asserts enable_block4

        din_real_0 = 16'd13; din_real_1 = 16'd14; din_real_2 = 16'd15; din_real_3 = 16'd16;
        $display("[%0t] TB: Applied data for Block 4 (during CU state INPUT4): %d, %d, %d, %d", $time, din_real_0, din_real_1, din_real_2, din_real_3);
        @(posedge clk); // CU moves to FINALIZE

        $display("[%0t] TB: All input blocks applied. Waiting for FFT completion (done signal)...", $time);
        wait (done === 1'b1);
        $display("[%0t] TB: FFT 'done' signal received.", $time);
        
        // Display results on the clock edge when 'done' is high or immediately after.
        // Since 'done' is asserted in FINALIZE, and dout_* are valid from start of FINALIZE,
        // we can display them here.
        $display("FFT Complete. Real and Imaginary Outputs at time %0t (when done is asserted):", $time);
        $display("Dout Real[0-3]:   %h, %h, %h, %h", dout_real_0, dout_real_1, dout_real_2, dout_real_3);
        $display("Dout Real[4-7]:   %h, %h, %h, %h", dout_real_4, dout_real_5, dout_real_6, dout_real_7);
        $display("Dout Real[8-11]:  %h, %h, %h, %h", dout_real_8, dout_real_9, dout_real_10, dout_real_11);
        $display("Dout Real[12-15]: %h, %h, %h, %h", dout_real_12, dout_real_13, dout_real_14, dout_real_15);
        $display("--------------------------------------------------");
        $display("Dout Imag[0-3]:   %h, %h, %h, %h", dout_imag_0, dout_imag_1, dout_imag_2, dout_imag_3);
        $display("Dout Imag[4-7]:   %h, %h, %h, %h", dout_imag_4, dout_imag_5, dout_imag_6, dout_imag_7);
        $display("Dout Imag[8-11]:  %h, %h, %h, %h", dout_imag_8, dout_imag_9, dout_imag_10, dout_imag_11);
        $display("Dout Imag[12-15]: %h, %h, %h, %h", dout_imag_12, dout_imag_13, dout_imag_14, dout_imag_15);

        @(posedge clk); // Observe 'done' deasserting as CU goes to IDLE

        #(CLK_PERIOD * 5) $display("[%0t] TB: Finishing simulation.", $time);
        $finish;
    end

    // Monitor internal CU state (optional, for debugging)
    // Note: Hierarchical paths like DUT.CU_inst.state might need specific simulator flags to be accessible.
    // always @(posedge clk) begin
    //     if (!reset) begin
    //         $display("[%0tns] CU_State: %d, En1:%b,En2:%b,En3:%b,En4:%b,DV:%b,Proc:%b,DU_Done:%b,CU_Done:%b",
    //             $time, DUT.CU_inst.state, DUT.enable_block1_internal, DUT.enable_block2_internal,
    //             DUT.enable_block3_internal, DUT.enable_block4_internal, DUT.data_valid_internal,
    //             DUT.process_internal, DUT.fft_done_internal, done);
    //     end
    // end

endmodule
