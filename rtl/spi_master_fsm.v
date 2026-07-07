module spi_master_fsm(
    input clk,
    input reset,
    input start,
    input [7:0] data_in,

    output reg mosi,
    output reg sclk,
    output reg cs,
    output reg done
);

    // FSM States
    parameter IDLE     = 3'b000;
    parameter LOAD     = 3'b001;
    parameter TRANSFER = 3'b010;
    parameter PARITY   = 3'b011;
    parameter DONE     = 3'b100;

    reg [2:0] state;

    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    reg parity_bit;

    always @(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            state <= IDLE;
            mosi <= 0;
            sclk <= 0;
            cs <= 1;
            done <= 0;
            bit_count <= 0;
        end

        else
        begin
            case(state)

                IDLE:
                begin
                    done <= 0;
                    cs <= 1;
                    sclk <= 0;

                    if(start)
                        state <= LOAD;
                end

                LOAD:
                begin
                    cs <= 0; // Enable slave
                    shift_reg <= data_in;
                    parity_bit <= ^data_in; //XOR parity 
                    bit_count <= 0;

                    state <= TRANSFER;
                end

                TRANSFER:
                begin
                    sclk <= ~sclk;

                    if(sclk == 0)
                    begin
                        mosi <= shift_reg[7];

                        shift_reg <= shift_reg << 1;

                        bit_count <= bit_count + 1;

                        if(bit_count == 7)
                            state <= PARITY;
                    end
                end

                PARITY:
                begin
                    mosi <= parity_bit;
                    state <= DONE;
                end
              
                DONE:
                begin
                    cs <= 1;
                    done <= 1;
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule
