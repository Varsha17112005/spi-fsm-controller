module spi_top(
    // System
    input clk,
    input reset,
    // User interface → master
    input start,
    input slave_select,    // 0 = Slave0,  1 = Slave1
    input [7:0] data_in,
    // Master status outputs
    output master_done,
    output ack,
    output parity_err_out,
    // Slave 0 outputs (monitor / debug)
    output [7:0] slave0_data_out,
    output slave0_parity_error,
    output slave0_done,
    // Slave 1 outputs (monitor / debug)
    output [7:0] slave1_data_out,
    output slave1_parity_error,
    output slave1_done
);
// ---------------------------------------------------------------------------
// Internal wires
// ---------------------------------------------------------------------------
wire mosi_w;           // MOSI  shared by both slaves
wire sclk_w;           // SCLK  shared by both slaves
wire [1:0]cs_w;             // CS[0] → Slave0 ,  CS[1] → Slave1
wire slave0_miso_w;    // Slave0 MISO feedback line
wire slave1_miso_w;    // Slave1 MISO feedback line
// ---------------------------------------------------------------------------
// MISO 2:1 mux
// ---------------------------------------------------------------------------
wire miso_w = (slave_select) ? slave1_miso_w : slave0_miso_w;
// ---------------------------------------------------------------------------
// Master instance
// ---------------------------------------------------------------------------
spi_master_fsm master_inst (
    .clk(clk),
    .reset(reset),
    .start(start),
    .slave_select(slave_select),
    .data_in(data_in),
    .miso(miso_w),           // Muxed MISO from active slave
    .mosi(mosi_w),
    .sclk(sclk_w),
    .cs(cs_w),
    .done(master_done),
    .ack(ack),
    .parity_err_out(parity_err_out)
);
// ---------------------------------------------------------------------------
// Slave 0  -  selected when cs_w[0] = 0
// ---------------------------------------------------------------------------
spi_slave slave0_inst (
    .reset(reset),
    .sclk(sclk_w),
    .cs(cs_w[0]),          // Active low: 0 when slave_select=0
    .mosi(mosi_w),
    .data_out(slave0_data_out),
    .parity_error(slave0_parity_error),
    .done(slave0_done),
    .miso(slave0_miso_w)
);
// ---------------------------------------------------------------------------
// Slave 1  -  selected when cs_w[1] = 0
// ---------------------------------------------------------------------------
spi_slave slave1_inst (
    .reset(reset),
    .sclk(sclk_w),
    .cs(cs_w[1]),          // Active low: 0 when slave_select=1
    .mosi(mosi_w),
    .data_out(slave1_data_out),
    .parity_error(slave1_parity_error),
    .done(slave1_done),
    .miso(slave1_miso_w)
);
endmodule
