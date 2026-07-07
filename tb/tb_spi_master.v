module tb_spi_master();

    reg clk;
    reg reset;
    reg start;
    reg [7:0] data_in;

    wire mosi;
    wire sclk;
    wire cs;
    wire done;

    spi_master_fsm uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(data_in),
        .mosi(mosi),
        .sclk(sclk),
        .cs(cs),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial
    begin
        clk = 0;
        reset = 1;
        start = 0;
        data_in = 8'b10110011;

        #20;
        reset = 0;

        #10;
        start = 1;

        #10;
        start = 0;

        #300;
        $finish;
    end

endmodule
