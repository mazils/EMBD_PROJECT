#include <rclcpp/rclcpp.hpp>
#include <sensor_msgs/msg/image.hpp>
#include "std_msgs/msg/int32_multi_array.hpp"

#include <cv_bridge/cv_bridge.h>
#include <opencv2/highgui/highgui.hpp>
#include <vector>
#include <iostream>
#include "reserved_mem.hpp"
#include "xnn_inference.h"

#define BUFFER_LENGTH 100

#define P_START 0x70000000
#define P_OFFSET 0

class ImageSubscriber : public rclcpp::Node
{
	// uint32_t *u_buff;
	// uint32_t *read_mem;
	rclcpp::Subscription<sensor_msgs::msg::Image>::SharedPtr camera_subscription_;
	rclcpp::Publisher<sensor_msgs::msg::Image>::SharedPtr cam_pub_red_res;
	//Reserved_Mem res_mem;
	uint8_t buffer[BUFFER_LENGTH];;
	std::mutex thread_lock;

	public:

	ImageSubscriber()
		: Node("minimal_subscriber")
	{
		// RCLCPP_INFO(this->get_logger(), "Initializing ImageSubscriber node");

		RCLCPP_INFO(this->get_logger(), "Starting camera subscription");

		camera_subscription_ = this->create_subscription<sensor_msgs::msg::Image>("/image_raw",10,std::bind(&ImageSubscriber::onImageMsg, this, std::placeholders::_1));
		cam_pub_red_res = this->create_publisher<sensor_msgs::msg::Image>("/image_raw_scaled_down",10);
		//allocate_memory();

		//res_mem=Reserved_Mem();
    	
	}
	//  ~ImageSubscriber()
    // {
    //     if (u_buff != nullptr)
    //     {
    //         free(u_buff);
    //     }
    // }

private:
	// void allocate_memory(){
	// 	u_buff = (uint32_t *)malloc(LENGTH);
	// 	if (u_buff == NULL)
	// 	{
	// 		RCLCPP_INFO(this->get_logger(), "could not allocate user buffer ");
	// 	}
	// 	else{
	// 		RCLCPP_INFO(this->get_logger(), "mem is allocated");
	// 	}
	// }
	

	void onImageMsg(const sensor_msgs::msg::Image::SharedPtr msg)
	{
		this->thread_lock.lock();
		std_msgs::msg::Int32MultiArray message;
		// RCLCPP_INFO(this->get_logger(), "Received image!");
		// RCLCPP_INFO(this->get_logger(), "My log message ");
		cv_bridge::CvImagePtr cv_ptr = cv_bridge::toCvCopy(msg, msg->encoding);
		cv::Mat img = cv_ptr->image;


		cv::Mat img_g;
		cv::cvtColor(img, img_g, cv::COLOR_BGR2GRAY);
		////////////////////Threshold image//////////////////////////

		cv::Mat img_thresholded;
    	cv::threshold(img_g, img_thresholded, 125, 255, cv::THRESH_BINARY);


		///////////////////Invert Image/////////////////////////////
		cv::Mat img_inverted;
		cv::bitwise_not(img_thresholded, img_inverted);
		
	//////////////image resising////////////////////

		cv::Mat img_resized;
		cv::resize(img_inverted, img_resized, cv::Size(10, 10), 0, 0, cv::INTER_AREA);
		// Optional: Normalize pixel values to 0-255
		img_resized.convertTo(img_resized, CV_8U);


//////////////////////////////////////////////////

/////////////////creating reduced frame message and publish/////////////////////////
		cv_bridge::CvImage cv_bridge_img;
		cv_bridge_img.image = img_resized;
		cv_bridge_img.encoding = sensor_msgs::image_encodings::MONO8; // For grayscale images
		sensor_msgs::msg::Image::SharedPtr msg_reduced = cv_bridge_img.toImageMsg();
		if (img_resized.empty()) {
				RCLCPP_ERROR(this->get_logger(), "Resized image is empty, cannot publish.");
				return;
		}
		RCLCPP_INFO(this->get_logger(), "Publishing reduced image.");
		cam_pub_red_res-> publish(*msg_reduced);
		

//////////////picture to array///////////
// 		std::vector<uint8_t> frame_vector;
		
// 		if (img_resized.isContinuous())
// 		{
// 			frame_vector.assign((uint8_t*)img_resized.datastart, (uint8_t*)img_resized.dataend);
// 		} 
// 		else 
// 		{
// 			for (int i = 0; i < img_resized.rows; ++i) 
// 			{
// 				frame_vector.insert(frame_vector.end(), img_resized.ptr<uint8_t>(i), img_resized.ptr<uint8_t>(i)+img_resized.cols);
// 			}
// 		}
// ///////////////////////////////////////////////////////
		
// 		// uint32_t arr[frame_vector.size()];

//     	// Copy elements from vector to array
//     	std::copy(frame_vector.begin(), frame_vector.end(), buffer);
		
// 		std::ostringstream oss;
// 		for (size_t i = 0; i < BUFFER_LENGTH; ++i) {
//     		oss << static_cast<int>(buffer[i]) << " "; // Cast uchar to int for proper display
// }
// 		RCLCPP_INFO(this->get_logger(), "Buffer contents: %s", oss.str().c_str());

// 		// int mem_ret = res_mem.transfer<uint8_t>(buffer, 0x0, BUFFER_LENGTH);

// 		// uint8_t tmp[100];
// 		// for (int i=0;i<100;i++){
		// 	tmp[i]=0;
		// }
		//res_mem.transfer<uint8_t>(tmp, 100, BUFFER_LENGTH);
		
		

	
		// XNn_inference xip;
    	// int status=XNn_inference_Initialize(&xip,"nn_inference");
    	// if (status!= XST_SUCCESS){
        // 	std::cout << "Cannot Init IP" << std::endl;
        // 	exit(1);
    	// }

    	// while(!XNn_inference_IsReady(&xip)){}

		// XNn_inference_Set_output_bus(&xip,0x70000000+BUFFER_LENGTH*sizeof(int));
		// XNn_inference_Set_input_img(&xip,0x70000000);

		
		//XNn_inference_Start(&xip);

		//while(!XNn_inference_IsDone(&xip)){}


// 		//reading the output
// 		uint8_t ret_buffer[105];
//     	res_mem.gather<uint8_t>(ret_buffer,0x0,105);
// 		std::ostringstream oss2;
// 		for (size_t i = 0; i < BUFFER_LENGTH; ++i) {
//     		oss2 << static_cast<int>(ret_buffer[i]) << " "; // Cast uchar to int for proper display
// }
// 		RCLCPP_INFO(this->get_logger(), "output Buffer contents: %s", oss2.str().c_str());
//         // std::cout << std::to_string(i) << ": "<<std::to_string(buffer[i]) << std::endl;
		
		
// 		RCLCPP_INFO(this->get_logger(),"read %d", ret_buffer[0]);
    	
		
		cv::waitKey(34);
		this->thread_lock.unlock();
	}
	

	
};

int main(int argc, char *argv[])
{
	setvbuf(stdout, NULL, _IONBF, BUFSIZ);
	rclcpp::init(argc, argv);
	rclcpp::spin(std::make_shared<ImageSubscriber>());
	rclcpp::shutdown();
	return 0;
}