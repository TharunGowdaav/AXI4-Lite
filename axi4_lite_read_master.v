

module axi4_lite_read_master #(
    parameter integer ADDR_WIDTH = 32,
    parameter integer DATA_WIDTH = 32
)(
    input  wire                     clk,
    input  wire                     resetn,
    input  wire                     rd_en,                 
    input  wire [ADDR_WIDTH-1:0]    rd_addr,               
    output reg  [DATA_WIDTH-1:0]    rd_data,               
    output reg  [ADDR_WIDTH-1:0]    AR_ADDR,
    output reg                      AR_VALID,
    input  wire                     AR_READY,
    input wire  [DATA_WIDTH-1:0]    R_DATA,
    input wire                      R_VALID,
    output reg                      R_READY,
    input wire                      R_RESP
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
                if (rd_en) begin
                    next_state = READ_ADDR;
                end else begin
                    next_state = IDLE;
                end
            end

            READ_ADDR: begin
                if (AR_READY) begin
                    next_state = READ_DATA;
                end else begin
                    next_state = READ_ADDR;
                end
            end

            READ_DATA: begin
                if (R_VALID) begin
                    next_state = IDLE;
                end else begin
                    next_state = READ_DATA;
                end
            end
            default: next_state = IDLE;
endcase
end
    always @(*) begin
                    AR_VALID = 0;
		    AR_ADDR = 32'd0;
                    R_READY = 0;
                    rd_data = 32'd0;
  case (current_state)
                IDLE: begin

                end

                READ_ADDR: begin
                AR_VALID = 1;
                if(AR_READY) begin
		AR_ADDR = rd_addr;
                end
                end

                READ_DATA: begin
                   R_READY = 1;
                   if(R_VALID) begin
                            rd_data=R_DATA;
	           end
                  
                end

            endcase
        end

endmodule

