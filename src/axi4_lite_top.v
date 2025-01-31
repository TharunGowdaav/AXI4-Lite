module axi4_lite_top #(
    parameter integer ADDR_WIDTH = 32,
    parameter integer DATA_WIDTH = 32
)(
    input  wire clk,
    input  wire resetn
);

    // Signals for read operations
    wire rd_en;
    wire [ADDR_WIDTH-1:0] rd_addr;
    wire [DATA_WIDTH-1:0] rd_data;
    wire AR_VALID;
    wire AR_READY;
    wire [ADDR_WIDTH-1:0] AR_ADDR;
    wire R_VALID;
    wire R_READY;
    wire [DATA_WIDTH-1:0] R_DATA;
    wire [1:0] R_RESP;

    // Signals for write operations
    wire wr_en;
    wire [ADDR_WIDTH-1:0] wr_addr;
    wire [DATA_WIDTH-1:0] wr_data;
    wire AW_VALID;
    wire AW_READY;
    wire [ADDR_WIDTH-1:0] AW_ADDR;
    wire W_VALID;
    wire W_READY;
    wire [DATA_WIDTH-1:0] W_DATA;
    wire [1:0] B_RESP;
    wire B_VALID;
    wire B_READY;
    wire [3:0] WSTRB;

    // Instantiate read master
    axi4_lite_read_master #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) read_master (
        .clk(clk),
        .resetn(resetn),
        .rd_en(rd_en),
        .rd_addr(rd_addr),
        .rd_data(rd_data),
        .AR_ADDR(AR_ADDR),
        .AR_VALID(AR_VALID),
        .AR_READY(AR_READY),
        .R_DATA(R_DATA),
        .R_VALID(R_VALID),
        .R_READY(R_READY),
        .R_RESP(R_RESP)
    );

    // Instantiate write master
    axi4_lite_write_master #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) write_master (
        .clk(clk),
        .resetn(resetn),
        .wr_en(wr_en),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .AW_ADDR(AW_ADDR),
        .AW_VALID(AW_VALID),
        .AW_READY(AW_READY),
        .W_DATA(W_DATA),
        .W_VALID(W_VALID),
        .W_READY(W_READY),
        .B_RESP(B_RESP),
        .B_VALID(B_VALID),
        .B_READY(B_READY),
        .WSTRB(WSTRB)
    );

    // Instantiate read slave
    axi4_lite_read_slave #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) read_slave (
        .clk(clk),
        .resetn(resetn),
        .rd_en(rd_en),
        .rd_addr(rd_addr),
        .rd_data(rd_data),
        .AR_ADDR(AR_ADDR),
        .AR_VALID(AR_VALID),
        .AR_READY(AR_READY),
        .R_DATA(R_DATA),
        .R_VALID(R_VALID),
        .R_READY(R_READY),
        .R_RESP(R_RESP)
    );

    // Instantiate write slave
    axi4_lite_write_slave #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) write_slave (
        .clk(clk),
        .resetn(resetn),
        .wr_en(wr_en),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .AW_ADDR(AW_ADDR),
        .AW_VALID(AW_VALID),
        .AW_READY(AW_READY),
        .W_DATA(W_DATA),
        .W_VALID(W_VALID),
        .W_READY(W_READY),
        .B_RESP(B_RESP),
        .B_VALID(B_VALID),
        .B_READY(B_READY),
        .WSTRB(WSTRB)
    );

endmodule
