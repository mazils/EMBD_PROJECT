#include <rclcpp/rclcpp.hpp>
#include <sensor_msgs/msg/image.hpp>
#include "std_msgs/msg/int32_multi_array.hpp"

#include <cv_bridge/cv_bridge.h>
#include <opencv2/highgui/highgui.hpp>
#include <vector>
#include <iostream>
#include "reserved_mem.hpp"
#include "ximage_processing.h"


#define BUFFER_LENGTH 100

#define P_START 0x70000000
#define P_OFFSET 0

class ImageSubscriber : public rclcpp::Node
{
	uint32_t *u_buff;
	uint32_t *read_mem;
	rclcpp::Subscription<sensor_msgs::msg::Image>::SharedPtr camera_subscription_;
	rclcpp::Publisher<std_msgs::msg::Int32MultiArray>::SharedPtr mem_pub_;

	rclcpp::Publisher<sensor_msgs::msg::Image>::SharedPtr cam_pub_red_res;
	Reserved_Mem res_mem;

	public:

	ImageSubscriber()
		: Node("minimal_subscriber")
	{
		// RCLCPP_INFO(this->get_logger(), "Initializing ImageSubscriber node");

		RCLCPP_INFO(this->get_logger(), "Starting camera subscription");

		camera_subscription_ = this->create_subscription<sensor_msgs::msg::Image>("/image_raw",10,std::bind(&ImageSubscriber::onImageMsg, this, std::placeholders::_1));

		cam_pub_red_res = this->create_publisher<sensor_msgs::msg::Image>("/image_raw_scaled_down",10);

		mem_pub_ = this->create_publisher<std_msgs::msg::Int32MultiArray>("/memory", 10);
		//allocate_memory();

		res_mem=Reserved_Mem();
    	int buffer[BUFFER_LENGTH];
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
		std_msgs::msg::Int32MultiArray message;
		// RCLCPP_INFO(this->get_logger(), "Received image!");
		// RCLCPP_INFO(this->get_logger(), "My log message ");
		cv_bridge::CvImagePtr cv_ptr = cv_bridge::toCvCopy(msg, msg->encoding);
		cv::Mat img = cv_ptr->image;


		cv::Mat img_g;
		cv::cvtColor(img, img, cv::COLOR_BGR2RGB);
		cv::cvtColor(img, img_g, cv::COLOR_RGB2GRAY);
		// Allocate memory for the array
		
		
	//////////////image resising////////////////////

		cv::Mat img_resized;
		cv::resize(img_g, img_resized, cv::Size(10, 10), 0, 0, cv::INTER_AREA);
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
		std::vector<uchar> frame_vector;
		
		if (img_resized.isContinuous())
		{
			frame_vector.assign((uchar*)img_resized.datastart, (uchar*)img_resized.dataend);
		} 
		else 
		{
			for (int i = 0; i < img_resized.rows; ++i) 
			{
				frame_vector.insert(frame_vector.end(), img_resized.ptr<uchar>(i), img_resized.ptr<uchar>(i)+img_resized.cols);
			}
		}
///////////////////////////////////////////////////////
		
		// uint32_t arr[frame_vector.size()];

    	// Copy elements from vector to array
    	std::copy(frame_vector.begin(), frame_vector.end(), buffer);
		
		// uint32_t u_array[BUFFER_LENGTH];
		// for (int i = 0; i < 100; i++) {
        // u_array[i] = i + 100; 
    	// }
		
		// u_buff = u_array;
		// u_buff = arr;
		//WORKS
		int mem_ret = res_mem.transfer(buffer, P_OFFSET, BUFFER_LENGTH);
	
		XImage_processing xip;
    	int status=XImage_processing_Initialize(&xip,"image_processing");
    	if (status!= XST_SUCCESS){
        	std::cout << "Cannot Init IP" << std::endl;
        	exit(1);
    	}

    	while(!XImage_processing_IsReady(&xip)){}

    	XImage_processing_Set_in_r(&xip,0x70000000);
    	XImage_processing_Set_out_r(&xip,0x70000000+BUFFER_LENGTH*sizeof(uint32_t));
    	XImage_processing_Start(&xip);

    	while(!XImage_processing_IsDone(&xip)){}


		//reading the output
		
    	res_mem.gather<int>(buffer,0,BUFFER_LENGTH);


        // std::cout << std::to_string(i) << ": "<<std::to_string(buffer[i]) << std::endl;
		
		for(int i=0;i<2;i++){
		RCLCPP_INFO(this->get_logger(), std::to_string(buffer[i]));
    }
		
		cv::waitKey(34);

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