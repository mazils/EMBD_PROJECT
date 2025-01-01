#include "matmul.hpp"


/* Layer 1 matrix multiplication */
void hwmm_layer1(volatile char input[n_inputs], const float weights[n_inputs][n_layer1], float output[1][n_layer1]) {
	layer_1_col: for (int j = 0; j < n_layer1; ++j) {
#pragma HLS UNROLL
      float sum = 0;

      layer_1_prod: for (int k = 0; k < n_inputs; ++k){
//#pragma HLS UNROLL
        sum += ((float)input[k])/255.0f * weights[k][j];
      }
      output[0][j] = sum;
    }

  return;
}



/* Layer 2 matrix multiplication */
void hwmm_layer2(float input[1][n_layer1], const float weights[n_layer1][n_layer2], float output[1][n_layer2]) {

	layer_2_col: for (int j = 0; j < n_layer2; ++j) {
//#pragma HLS UNROLL
      float sum = 0;

      layer_2_prod: for (int k = 0; k < n_layer1; ++k){
//#pragma HLS UNROLL
        sum += input[0][k] * weights[k][j];
      }
      output[0][j] = sum;
    }


  return;
}



/* Layer 3 matrix multiplication */
void hwmm_layer3(float input[1][n_layer2], const float weights[n_layer2][n_layer3], float output[1][n_layer3]) {

    layer_3_col: for (int j = 0; j < n_layer3; ++j) {
//#pragma HLS UNROLL
      float sum = 0;

      layer_3_prod: for (int k = 0; k < n_layer2; ++k){
//#pragma HLS UNROLL
        sum += input[0][k] * weights[k][j];
      }
      output[0][j] = sum;
    }

  return;
}



/* ReLU layer 1 activation function */
void hw_act_layer1(float input[1][n_layer1], float output[1][n_layer1]){
	layer_1_act: for (int i = 0; i < n_layer1; i++){
//#pragma HLS UNROLL
		if (input[0][i] < 0.0)
			output[0][i] = 0.0;
		else
			output[0][i] = input[0][i];
	}

	return;
}



/* ReLU layer 2 activation function */
void hw_act_layer2(float input[1][n_layer2], float output[1][n_layer2]){
	layer_2_act: for (int i = 0; i < n_layer2; i++){
//#pragma HLS UNROLL
		if (input[0][i] < 0.0)
			output[0][i] = 0.0;
		else
			output[0][i] = input[0][i];
	}

	return;
}



/* Softmax layer 3 activation function */
void hw_act_layer3(float input[1][n_layer3], int &pred){
	int max_idx = -1;
	float max_val = -1; //-999.9
	layer_3_act: for (int i = 0; i < n_layer3; i++){
//#pragma HLS UNROLL
		#pragma HLS PIPELINE II=2 // Insert pipeline stages
		if (input[0][i] > max_val){
			max_idx = i;
			max_val = input[0][i];
		}
	}
	pred = max_idx;
	return;
}



/* Connect NN Layers */
void nn_inference(volatile char input_img[n_inputs],volatile char output_bus[1],volatile char &out_wire){
	#pragma HLS INTERFACE s_axilite port=return
	#pragma HLS INTERFACE m_axi port=input_img offset=slave bundle=AXI_DATA max_widen_bitwidth=128
	#pragma HLS INTERFACE m_axi port=output_bus offset=slave bundle=AXI_DATA max_widen_bitwidth=128
	#pragma HLS INTERFACE ap_ovld port=out_wire


//#pragma HLS ARRAY_PARTITION dim=1 type=complete variable=input_img

	float temp_output[1][n_layer1] = {1};
	float temp_output2[1][n_layer2] = {1};
	float temp_output3[1][n_layer3] = {1};
	int prediction = -1;

	hwmm_layer1(input_img, weights::layer1_weights, temp_output);
	hw_act_layer1(temp_output, temp_output);
	hwmm_layer2(temp_output, weights::layer2_weights, temp_output2);
	hw_act_layer2(temp_output2, temp_output2);
	hwmm_layer3(temp_output2, weights::layer3_weights, temp_output3);
	hw_act_layer3(temp_output3, prediction);

	output_bus[0]=(char)prediction;
	out_wire=(char)prediction;

}
