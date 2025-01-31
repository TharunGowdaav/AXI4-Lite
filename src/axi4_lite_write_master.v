

module axi4_lite_write_master #(
    parameter integer ADDR_WIDTH = 32,
    parameter integer DATA_WIDTH = 32
)
 (
    input  wire                     clk,
    input  wire                     resetn,
    input  wire                     wr_en,                 
    input  wire [ADDR_WIDTH-1:0]    wr_addr,               
    input  wire [DATA_WIDTH-1:0]    wr_data,               
    output reg  [ADDR_WIDTH-1:0]    AW_ADDR,
    output reg                      AW_VALID,
    input  wire                     AW_READY,
    output reg  [DATA_WIDTH-1:0]    W_DATA,
    output reg                      W_VALID,
    input  wire                     W_READY,
    input  wire [1:0]               B_RESP,
    input  wire                     B_VALID,
    output reg                      B_READY,
    output reg [3:0]                WSTRB

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
                if (wr_en) begin
                    next_state = WRITE_ADDR;
                end else begin
                    next_state = IDLE;
                end
            end

            WRITE_ADDR: begin
                if (AW_READY) begin
                    next_state = WRITE_DATA;
                end else begin
                    next_state = WRITE_ADDR;
                end
            end

            WRITE_DATA: begin
                if (W_READY) begin
                    next_state = WAIT_RESPONSE;
                end else begin
                    next_state = WRITE_DATA;
                end
            end

            WAIT_RESPONSE: begin
                if (B_VALID) begin
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
                    AW_VALID = 0;
		    AW_ADDR = 32'd0;
                    W_VALID = 0;
                    B_READY = 0;
                    WSTRB = 4'd0;
                    W_DATA = 32'd0;
  case (current_state)
                IDLE: begin

                end

                WRITE_ADDR: begin
                AW_VALID = 1;
                if(AW_READY) begin
		AW_ADDR = wr_addr;
                end
                end

                WRITE_DATA: begin
                   W_VALID = 1;
                   if(W_READY) begin
                           W_DATA = wr_data;
	           end
                  
                end

                WAIT_RESPONSE: begin
                    B_READY = 1;
 		if(B_VALID) begin
		end                
	end
endcase
        end

endmodule


