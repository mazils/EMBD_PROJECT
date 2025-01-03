// ==============================================================
// RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2021.1 (64-bit)
// Version: 2021.1
// Copyright (C) Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

module nn_inference_nn_inference_Pipeline_loop13 (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        temp_output3_0_address0,
        temp_output3_0_ce0,
        temp_output3_0_q0,
        max_idx_out,
        max_idx_out_ap_vld,
        grp_fu_1332_p_din0,
        grp_fu_1332_p_din1,
        grp_fu_1332_p_opcode,
        grp_fu_1332_p_dout0,
        grp_fu_1332_p_ce
);

parameter    ap_ST_fsm_pp0_stage0 = 2'd1;
parameter    ap_ST_fsm_pp0_stage1 = 2'd2;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
output  [3:0] temp_output3_0_address0;
output   temp_output3_0_ce0;
input  [31:0] temp_output3_0_q0;
output  [31:0] max_idx_out;
output   max_idx_out_ap_vld;
output  [31:0] grp_fu_1332_p_din0;
output  [31:0] grp_fu_1332_p_din1;
output  [4:0] grp_fu_1332_p_opcode;
input  [0:0] grp_fu_1332_p_dout0;
output   grp_fu_1332_p_ce;

reg ap_idle;
reg temp_output3_0_ce0;
reg max_idx_out_ap_vld;

(* fsm_encoding = "none" *) reg   [1:0] ap_CS_fsm;
wire    ap_CS_fsm_pp0_stage0;
reg    ap_enable_reg_pp0_iter0;
reg    ap_enable_reg_pp0_iter1;
reg    ap_enable_reg_pp0_iter2;
reg    ap_idle_pp0;
wire    ap_CS_fsm_pp0_stage1;
wire    ap_block_state2_pp0_stage1_iter0;
wire    ap_block_state4_pp0_stage1_iter1;
wire    ap_block_pp0_stage1_subdone;
reg   [0:0] icmp_ln102_reg_265;
reg    ap_condition_exit_pp0_iter0_stage1;
wire    ap_loop_exit_ready;
reg    ap_ready_int;
wire    ap_block_state1_pp0_stage0_iter0;
wire    ap_block_state3_pp0_stage0_iter1;
wire    ap_block_state5_pp0_stage0_iter2;
wire    ap_block_pp0_stage0_11001;
reg   [3:0] i_reg_260;
reg   [3:0] i_reg_260_pp0_iter1_reg;
wire   [0:0] icmp_ln102_fu_98_p2;
reg   [31:0] max_val_1_reg_274;
wire    ap_block_pp0_stage1_11001;
reg   [31:0] max_val_load_reg_281;
wire   [0:0] and_ln104_1_fu_200_p2;
reg   [0:0] and_ln104_1_reg_288;
wire   [31:0] max_val_2_fu_206_p3;
reg   [31:0] max_val_2_reg_293;
reg    ap_enable_reg_pp0_iter0_reg;
wire    ap_block_pp0_stage0_subdone;
wire   [63:0] trunc_ln104_cast_fu_110_p1;
wire    ap_block_pp0_stage0;
reg   [31:0] max_idx_fu_44;
wire   [31:0] max_idx_4_fu_218_p3;
wire    ap_loop_init;
reg   [31:0] max_val_fu_48;
reg   [31:0] ap_sig_allocacmp_max_val_load;
reg   [3:0] max_idx_1_fu_52;
reg   [3:0] ap_sig_allocacmp_i;
wire   [3:0] add_ln102_fu_104_p2;
wire    ap_block_pp0_stage0_01001;
wire    ap_block_pp0_stage1;
wire   [31:0] bitcast_ln104_fu_124_p1;
wire   [31:0] bitcast_ln104_1_fu_141_p1;
wire   [7:0] tmp_4_fu_127_p4;
wire   [22:0] trunc_ln104_fu_137_p1;
wire   [0:0] icmp_ln104_1_fu_164_p2;
wire   [0:0] icmp_ln104_fu_158_p2;
wire   [7:0] tmp_5_fu_144_p4;
wire   [22:0] trunc_ln104_1_fu_154_p1;
wire   [0:0] icmp_ln104_3_fu_182_p2;
wire   [0:0] icmp_ln104_2_fu_176_p2;
wire   [0:0] or_ln104_fu_170_p2;
wire   [0:0] and_ln104_fu_194_p2;
wire   [0:0] or_ln104_1_fu_188_p2;
wire   [31:0] zext_ln104_fu_215_p1;
wire    ap_block_pp0_stage0_00001;
reg    ap_done_reg;
wire    ap_continue_int;
reg    ap_done_int;
reg    ap_loop_exit_ready_pp0_iter1_reg;
reg    ap_condition_exit_pp0_iter1_stage0;
reg    ap_idle_pp0_0to0;
reg   [1:0] ap_NS_fsm;
reg    ap_idle_pp0_1to2;
wire    ap_enable_pp0;
wire    ap_start_int;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_CS_fsm = 2'd1;
#0 ap_enable_reg_pp0_iter1 = 1'b0;
#0 ap_enable_reg_pp0_iter2 = 1'b0;
#0 ap_enable_reg_pp0_iter0_reg = 1'b0;
#0 ap_done_reg = 1'b0;
end

nn_inference_flow_control_loop_pipe_sequential_init flow_control_loop_pipe_sequential_init_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(ap_start),
    .ap_ready(ap_ready),
    .ap_done(ap_done),
    .ap_start_int(ap_start_int),
    .ap_loop_init(ap_loop_init),
    .ap_ready_int(ap_ready_int),
    .ap_loop_exit_ready(ap_condition_exit_pp0_iter0_stage1),
    .ap_loop_exit_done(ap_done_int),
    .ap_continue_int(ap_continue_int),
    .ap_done_int(ap_done_int)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_pp0_stage0;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_done_reg <= 1'b0;
    end else begin
        if ((ap_continue_int == 1'b1)) begin
            ap_done_reg <= 1'b0;
        end else if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_loop_exit_ready_pp0_iter1_reg == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            ap_done_reg <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter0_reg <= 1'b0;
    end else begin
        if ((1'b1 == ap_CS_fsm_pp0_stage0)) begin
            ap_enable_reg_pp0_iter0_reg <= ap_start_int;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter1 <= 1'b0;
    end else begin
        if ((1'b1 == ap_condition_exit_pp0_iter0_stage1)) begin
            ap_enable_reg_pp0_iter1 <= 1'b0;
        end else if (((1'b0 == ap_block_pp0_stage1_subdone) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
            ap_enable_reg_pp0_iter1 <= ap_enable_reg_pp0_iter0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter2 <= 1'b0;
    end else begin
        if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            ap_enable_reg_pp0_iter2 <= 1'b0;
        end else if (((1'b0 == ap_block_pp0_stage1_subdone) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
            ap_enable_reg_pp0_iter2 <= ap_enable_reg_pp0_iter1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((ap_idle_pp0_0to0 == 1'b1) & (1'b1 == ap_condition_exit_pp0_iter1_stage0))) begin
        ap_loop_exit_ready_pp0_iter1_reg <= 1'b0;
    end else if (((1'b0 == ap_block_pp0_stage1_11001) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        ap_loop_exit_ready_pp0_iter1_reg <= ap_loop_exit_ready;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        if (((icmp_ln102_fu_98_p2 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1))) begin
            max_idx_1_fu_52 <= add_ln102_fu_104_p2;
        end else if ((ap_loop_init == 1'b1)) begin
            max_idx_1_fu_52 <= 4'd0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        if ((ap_loop_init == 1'b1)) begin
            max_idx_fu_44 <= 32'd4294967295;
        end else if ((ap_enable_reg_pp0_iter2 == 1'b1)) begin
            max_idx_fu_44 <= max_idx_4_fu_218_p3;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        if ((ap_loop_init == 1'b1)) begin
            max_val_fu_48 <= 32'd3296328090;
        end else if ((ap_enable_reg_pp0_iter2 == 1'b1)) begin
            max_val_fu_48 <= max_val_2_reg_293;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage1_11001) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        and_ln104_1_reg_288 <= and_ln104_1_fu_200_p2;
        max_val_2_reg_293 <= max_val_2_fu_206_p3;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        i_reg_260 <= ap_sig_allocacmp_i;
        i_reg_260_pp0_iter1_reg <= i_reg_260;
        icmp_ln102_reg_265 <= icmp_ln102_fu_98_p2;
        max_val_load_reg_281 <= ap_sig_allocacmp_max_val_load;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln102_reg_265 == 1'd0) & (1'b0 == ap_block_pp0_stage1_11001) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        max_val_1_reg_274 <= temp_output3_0_q0;
    end
end

always @ (*) begin
    if (((icmp_ln102_reg_265 == 1'd1) & (1'b0 == ap_block_pp0_stage1_subdone) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        ap_condition_exit_pp0_iter0_stage1 = 1'b1;
    end else begin
        ap_condition_exit_pp0_iter0_stage1 = 1'b0;
    end
end

always @ (*) begin
    if (((icmp_ln102_reg_265 == 1'd1) & (1'b0 == ap_block_pp0_stage0_subdone) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_condition_exit_pp0_iter1_stage0 = 1'b1;
    end else begin
        ap_condition_exit_pp0_iter1_stage0 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_loop_exit_ready_pp0_iter1_reg == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_done_int = 1'b1;
    end else begin
        ap_done_int = ap_done_reg;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_pp0_stage0)) begin
        ap_enable_reg_pp0_iter0 = ap_start_int;
    end else begin
        ap_enable_reg_pp0_iter0 = ap_enable_reg_pp0_iter0_reg;
    end
end

always @ (*) begin
    if (((ap_idle_pp0 == 1'b1) & (ap_start_int == 1'b0) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp0_iter2 == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b0))) begin
        ap_idle_pp0 = 1'b1;
    end else begin
        ap_idle_pp0 = 1'b0;
    end
end

always @ (*) begin
    if ((ap_enable_reg_pp0_iter0 == 1'b0)) begin
        ap_idle_pp0_0to0 = 1'b1;
    end else begin
        ap_idle_pp0_0to0 = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp0_iter2 == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b0))) begin
        ap_idle_pp0_1to2 = 1'b1;
    end else begin
        ap_idle_pp0_1to2 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage1_subdone) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        ap_ready_int = 1'b1;
    end else begin
        ap_ready_int = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (1'b1 == ap_CS_fsm_pp0_stage0) & (ap_loop_init == 1'b1))) begin
        ap_sig_allocacmp_i = 4'd0;
    end else begin
        ap_sig_allocacmp_i = max_idx_1_fu_52;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_sig_allocacmp_max_val_load = max_val_2_reg_293;
    end else begin
        ap_sig_allocacmp_max_val_load = max_val_fu_48;
    end
end

always @ (*) begin
    if (((icmp_ln102_reg_265 == 1'd1) & (1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        max_idx_out_ap_vld = 1'b1;
    end else begin
        max_idx_out_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        temp_output3_0_ce0 = 1'b1;
    end else begin
        temp_output3_0_ce0 = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_pp0_stage0 : begin
            if (((ap_idle_pp0_0to0 == 1'b1) & (1'b1 == ap_condition_exit_pp0_iter1_stage0))) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end else if ((~((ap_start_int == 1'b0) & (ap_idle_pp0_1to2 == 1'b1)) & (1'b0 == ap_block_pp0_stage0_subdone))) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end
        end
        ap_ST_fsm_pp0_stage1 : begin
            if ((1'b0 == ap_block_pp0_stage1_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage1;
            end
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign add_ln102_fu_104_p2 = (ap_sig_allocacmp_i + 4'd1);

assign and_ln104_1_fu_200_p2 = (or_ln104_1_fu_188_p2 & and_ln104_fu_194_p2);

assign and_ln104_fu_194_p2 = (or_ln104_fu_170_p2 & grp_fu_1332_p_dout0);

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_pp0_stage1 = ap_CS_fsm[32'd1];

assign ap_block_pp0_stage0 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_00001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_01001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_11001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_subdone = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage1 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage1_11001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage1_subdone = ~(1'b1 == 1'b1);

assign ap_block_state1_pp0_stage0_iter0 = ~(1'b1 == 1'b1);

assign ap_block_state2_pp0_stage1_iter0 = ~(1'b1 == 1'b1);

assign ap_block_state3_pp0_stage0_iter1 = ~(1'b1 == 1'b1);

assign ap_block_state4_pp0_stage1_iter1 = ~(1'b1 == 1'b1);

assign ap_block_state5_pp0_stage0_iter2 = ~(1'b1 == 1'b1);

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

assign ap_loop_exit_ready = ap_condition_exit_pp0_iter0_stage1;

assign bitcast_ln104_1_fu_141_p1 = max_val_load_reg_281;

assign bitcast_ln104_fu_124_p1 = max_val_1_reg_274;

assign grp_fu_1332_p_ce = 1'b1;

assign grp_fu_1332_p_din0 = max_val_1_reg_274;

assign grp_fu_1332_p_din1 = ap_sig_allocacmp_max_val_load;

assign grp_fu_1332_p_opcode = 5'd2;

assign icmp_ln102_fu_98_p2 = ((ap_sig_allocacmp_i == 4'd10) ? 1'b1 : 1'b0);

assign icmp_ln104_1_fu_164_p2 = ((trunc_ln104_fu_137_p1 == 23'd0) ? 1'b1 : 1'b0);

assign icmp_ln104_2_fu_176_p2 = ((tmp_5_fu_144_p4 != 8'd255) ? 1'b1 : 1'b0);

assign icmp_ln104_3_fu_182_p2 = ((trunc_ln104_1_fu_154_p1 == 23'd0) ? 1'b1 : 1'b0);

assign icmp_ln104_fu_158_p2 = ((tmp_4_fu_127_p4 != 8'd255) ? 1'b1 : 1'b0);

assign max_idx_4_fu_218_p3 = ((and_ln104_1_reg_288[0:0] == 1'b1) ? zext_ln104_fu_215_p1 : max_idx_fu_44);

assign max_idx_out = max_idx_fu_44;

assign max_val_2_fu_206_p3 = ((and_ln104_1_fu_200_p2[0:0] == 1'b1) ? max_val_1_reg_274 : max_val_load_reg_281);

assign or_ln104_1_fu_188_p2 = (icmp_ln104_3_fu_182_p2 | icmp_ln104_2_fu_176_p2);

assign or_ln104_fu_170_p2 = (icmp_ln104_fu_158_p2 | icmp_ln104_1_fu_164_p2);

assign temp_output3_0_address0 = trunc_ln104_cast_fu_110_p1;

assign tmp_4_fu_127_p4 = {{bitcast_ln104_fu_124_p1[30:23]}};

assign tmp_5_fu_144_p4 = {{bitcast_ln104_1_fu_141_p1[30:23]}};

assign trunc_ln104_1_fu_154_p1 = bitcast_ln104_1_fu_141_p1[22:0];

assign trunc_ln104_cast_fu_110_p1 = ap_sig_allocacmp_i;

assign trunc_ln104_fu_137_p1 = bitcast_ln104_fu_124_p1[22:0];

assign zext_ln104_fu_215_p1 = i_reg_260_pp0_iter1_reg;

endmodule //nn_inference_nn_inference_Pipeline_loop13
