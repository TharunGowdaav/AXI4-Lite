`timescale 1ns / 1ps

module axi4_lite_read_slave #(
    parameter integer ADDR_WIDTH = 32,
    parameter integer DATA_WIDTH = 32
)(
    input  wire                     clk,
    input  wire                     resetn,
    output  reg                     rd_en,                 
    output  reg [ADDR_WIDTH-1:0]    rd_addr,               
    input wire  [DATA_WIDTH-1:0]    rd_data,               
    input wire  [ADDR_WIDTH-1:0]    AR_ADDR,
    input wire                      AR_VALID,
    output reg                      AR_READY,
    output reg  [DATA_WIDTH-1:0]    R_DATA,
    output reg                      R_VALID,
    input wire                      R_READY,
    output reg  [1:0]               R_RESP
);

    localparam  IDLE = 2'b00;
    localparam  READ_ADDR = 2'b01;
    localparam  READ_DATA = 2'b10;
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
                if (AR_VALID) begin
                    next_state = READ_ADDR;
                end else begin
                    next_state = IDLE;
                end
            end

            READ_ADDR: begin
                if (AR_VALID && AR_READY) begin
                    next_state = READ_DATA;
                end else begin
                    next_state = READ_ADDR;
                end
            end

            READ_DATA: begin
                if (R_VALID && R_READY) begin
                    next_state = IDLE;
                end else begin
                    next_state = READ_DATA;
                end
            end
            default: next_state = IDLE;
endcase
end
    always @(*) begin
                    rd_en=0;
		    rd_addr=0;
		    AR_READY=0;
		    R_DATA=32'd0;
		    R_RESP=2'd0;
		    
		    
		    
  case (current_state)
                IDLE: begin

                end

                READ_ADDR: begin
                AR_READY = 1;
                if(AR_VALID) begin
		rd_addr=AR_ADDR;
rd_en=1;
                end

                end

                READ_DATA: begin
                   R_VALID = 1;
                   if(R_READY) begin
                            R_DATA=rd_data;
	           end
                  
                end

            endcase
        end

endmodule

