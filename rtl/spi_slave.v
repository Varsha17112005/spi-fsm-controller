module spi_slave(
    input reset,
    input sclk,        // SPI clock from master (rising-edge capture)
    input cs,          // Chip-select, active low (0 = selected)
    input mosi,        // Master Out Slave In
    output reg [7:0] data_out,    // Received 8-bit data (latched after parity check)
    output reg parity_error,// 1 = parity mismatch, 0 = OK
    output reg done,        // Pulses high when transfer is complete
    output reg miso         // MISO feedback: 1=ACK, 0=NACK (parity error)
);
parameter IDLE         = 2'd0,
          RECEIVE      = 2'd1,
          PARITY_CHECK = 2'd2,
          DONE_STATE   = 2'd3;
          
reg [1:0] state;
reg [7:0] shift_reg;          // Shift register - accumulates received bits
reg [2:0] bit_count;          // Number of bits captured so far
reg received_parity;    // Parity bit received from master (bit 9)
reg calculated_parity;  // XOR of all 8 received data bits

always @(posedge sclk or posedge reset)
begin
    if(reset)
    begin
        state <= IDLE;
        shift_reg <= 8'd0;
        bit_count <= 3'd0;
        received_parity <= 1'b0;
        calculated_parity <= 1'b0;
        parity_error <= 1'b0;
        done <= 1'b0;
        miso <= 1'b0;
        data_out <= 8'd0;
    end

    else
    begin
        case(state)
        //--------------------------------------------------
        // IDLE
        //--------------------------------------------------
        IDLE:
        begin
            done      <= 1'b0;
            miso      <= 1'b0;
            bit_count <= 3'd0;

            if(cs == 1'b0)
            begin
                shift_reg <= {shift_reg[6:0], mosi};   // Capture MSB
                bit_count <= 3'd1;
                state     <= RECEIVE;
            end
        end
        //--------------------------------------------------
        // RECEIVE
        //--------------------------------------------------
        RECEIVE:
        begin
            if(cs == 1'b0)
            begin
                shift_reg <= {shift_reg[6:0], mosi};
                bit_count <= bit_count + 1'b1;

                if(bit_count == 3'd7)
                    state <= PARITY_CHECK;
            end
            else
            begin
                state <= IDLE;
            end
        end
        //--------------------------------------------------
        // PARITY CHECK
        //--------------------------------------------------
        PARITY_CHECK:
        begin
            if(cs == 1'b0)
            begin
                received_parity   <= mosi;
                calculated_parity <= ^shift_reg;

                if(mosi == ^shift_reg)
                    parity_error <= 1'b0;
                else
                    parity_error <= 1'b1;

                data_out <= shift_reg;

                state <= DONE_STATE;
            end
            else
            begin
                state <= IDLE;
            end
        end
        //--------------------------------------------------
        // DONE
        //--------------------------------------------------
        DONE_STATE:
        begin
            done <= 1'b1;

            if(parity_error)
                miso <= 1'b0;      // NACK
            else
                miso <= 1'b1;      // ACK

            state <= IDLE;
        end

        default:
            state <= IDLE;

        endcase
    end
end
endmodule
