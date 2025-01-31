`timescale 1ns / 1ps

module axi4_lite_write_slave #(
    parameter integer ADDR_WIDTH = 32,
    parameter integer DATA_WIDTH = 32
)
 (
    input  wire                     clk,
    input  wire                     resetn,
    output  reg                     wr_en,                 
    output  reg [ADDR_WIDTH-1:0]    wr_addr,               
    output  reg [DATA_WIDTH-1:0]    wr_data,               
    input wire  [ADDR_WIDTH-1:0]    AW_ADDR,
    input wire                      AW_VALID,
    output  reg                     AW_READY,
    input wire  [DATA_WIDTH-1:0]    W_DATA,
    input wire                      W_VALID,
    output  reg                     W_READY,
    output  reg [1:0]               B_RESP,
    output  reg                     B_VALID,
    input wire                      B_READY,
    input wire [3:0]                WSTRB

);


    localparam  IDLE = 2'b00;
    localparam  WRITE_ADDR = 2'b01;
    localparam  WRITE_DATA = 2'b10;
    localparam  WAIT_RESPONSE = 2'b11;

    reg [1:0] current_state, next_state;

    // State transition logic
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (AW_VALID) begin
                    next_state = WRITE_ADDR;
                end else begin
                    next_state = IDLE;
                end
            end

            WRITE_ADDR: begin
                if (AW_VALID && AW_READY) begin
                    next_state = WRITE_DATA;
                end else begin
                    next_state = WRITE_ADDR;
                end
            end

            WRITE_DATA: begin
                if (W_READY && W_VALID) begin
                    next_state = WAIT_RESPONSE;
                end else begin
                    next_state = WRITE_DATA;
                end
            end

            WAIT_RESPONSE: begin
                if (B_VALID && B_READY) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_RESPONSE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
            AW_READY = 0;
            W_READY = 0;
		    B_RESP=2'd0;
		    B_VALID=0;
		    wr_data = 32'd0;
		    wr_addr = 32'd0;
		    wr_en = 0;
  case (current_state)
                IDLE: begin

                end

                WRITE_ADDR: begin
                AW_READY=1;
			if(AW_VALID) begin
				wr_addr = AW_ADDR;
			end
                end

                WRITE_DATA: begin
                W_READY = 1;
                if (W_VALID) begin
                    case (WSTRB)
                        4'b0000: wr_data = W_DATA;
                        4'b0001: wr_data = {24'd0, W_DATA[7:0]};
                        4'b0010: wr_data = {16'd0, W_DATA[15:8], 8'd0};
                        4'b0100: wr_data = {8'd0, W_DATA[23:16], 16'd0};
                        4'b0011: wr_data = {16'd0, W_DATA[15:0]};
                        4'b0110: wr_data = {8'd0, W_DATA[23:8], 8'd0};
                        default: wr_data = W_DATA;
                    endcase
                    wr_en = 1;
                end
            end

                WAIT_RESPONSE: begin
                B_VALID=1;
		B_RESP=2'd0;
			if(B_READY) begin 
				B_VALID=0;
			end                  
	        end
endcase
        end

endmodule


