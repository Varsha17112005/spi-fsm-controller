`timescale 1ns / 1ps

module tb_spi_top;

    // Inputs
    reg clk;
    reg reset;
    reg start;
    reg slave_select;
    reg [7:0] data_in;

    // Outputs
    wire master_done;
    wire ack;
    wire parity_err_out;

    wire [7:0] slave0_data_out;
    wire slave0_parity_error;
    wire slave0_done;

    wire [7:0] slave1_data_out;
    wire slave1_parity_error;
    wire slave1_done;

    //--------------------------------------------------------
    // Instantiate Top Module
    //--------------------------------------------------------
    spi_top DUT(
        .clk(clk),
        .reset(reset),
        .start(start),
        .slave_select(slave_select),
        .data_in(data_in),

        .master_done(master_done),
        .ack(ack),
        .parity_err_out(parity_err_out),

        .slave0_data_out(slave0_data_out),
        .slave0_parity_error(slave0_parity_error),
        .slave0_done(slave0_done),

        .slave1_data_out(slave1_data_out),
        .slave1_parity_error(slave1_parity_error),
        .slave1_done(slave1_done)
    );

    //--------------------------------------------------------
    // Clock Generation (100 MHz)
    //--------------------------------------------------------
    initial
    begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //--------------------------------------------------------
    // Test Sequence
    //--------------------------------------------------------
    initial
    begin

        // Initialize
        reset = 1;
        start = 0;
        slave_select = 0;
        data_in = 8'h00;

        #20;
        reset = 0;

        //----------------------------------------------------
        // Test Case 1 : Send to Slave 0
        //----------------------------------------------------
        #20;
        slave_select = 0;
        data_in = 8'hA5;      //10100101

        start = 1;
        #10;
        start = 0;

        wait(master_done);

        #50;

        //----------------------------------------------------
        // Test Case 2 : Send to Slave 1
        //----------------------------------------------------
        slave_select = 1;
        data_in = 8'h3C;      //00111100

        start = 1;
        #10;
        start = 0;

        wait(master_done);

        #50;

        //----------------------------------------------------
        // Finish Simulation
        //----------------------------------------------------
        $finish;

    end

    //--------------------------------------------------------
    // Monitor Signals
    //--------------------------------------------------------
    initial
    begin
        $monitor(
        "Time=%0t | CS=%b | MOSI=%b | SCLK=%b | ACK=%b | PER=%b | DONE=%b | Slave0_Data=%h | Slave1_Data=%h",
        $time,
        DUT.cs_w,
        DUT.mosi_w,
        DUT.sclk_w,
        ack,
        parity_err_out,
        master_done,
        slave0_data_out,
        slave1_data_out
        );
    end

endmodule
