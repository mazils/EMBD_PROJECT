#include <chrono>
#include <functional>
#include <memory>
#include <string>
#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>
#include <stdlib.h>

#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"
#include "std_msgs/msg/int32.hpp"
#include "sensor_msgs/msg/image.hpp"
#include "xnn_inference.h"
#include "reserved_mem.hpp"


#include <cv_bridge/cv_bridge.h>
#include <opencv2/highgui/highgui.hpp>


using namespace std::chrono_literals;

/* This example creates a subclass of Node and uses std::bind() to register a
* member function as a callback from the timer. */

uint8_t testArray[100];
uint8_t result[1];
Reserved_Mem resv_mem=Reserved_Mem();
std::mutex thread_lock;
XNn_inference xip;
rclcpp::Publisher<std_msgs::msg::Int32>::SharedPtr publisher_;
rclcpp::Subscription<sensor_msgs::msg::Image>::SharedPtr subscription_;

class MinimalPublisher : public rclcpp::Node
{
  public:
    MinimalPublisher(): Node("minimal_publisher")
    {
      RCLCPP_INFO(this->get_logger(), "Starting listening for '/image_raw_scaled_down'");
      publisher_ = this->create_publisher<std_msgs::msg::Int32>("/set_draw_number", 10);
      subscription_ = this->create_subscription<sensor_msgs::msg::Image>(
      "/image_raw_scaled_down", 10, std::bind(&MinimalPublisher::get_image_callback, this,std::placeholders::_1));
      xip=XNn_inference();
      int status=XNn_inference_Initialize(&xip,"nn_inference");
      if(status!= XST_SUCCESS){
        RCLCPP_INFO(this->get_logger(), "Cannot Init IP");
        exit(0);
      }
      while(!XNn_inference_IsReady(&xip)){}
      XNn_inference_DisableAutoRestart(&xip);
      XNn_inference_Set_input_img(&xip,0x70000000);
      XNn_inference_Set_output_bus(&xip,0x70000000+100*sizeof(int));
    }

  private:

    void get_image_callback(const sensor_msgs::msg::Image::SharedPtr msg)
    {
      this->thread_lock.lock();
      RCLCPP_INFO(this->get_logger(), "Received Image");

      //convert image to array
      uint8_t *ImageArray=msg->data.data();

      for(int i=0;i<100;i++){
        testArray[i]=msg->data[i];
      }

      resv_mem.transfer(testArray,0x0,100);

      while(!XNn_inference_IsReady(&xip)){}

      XNn_inference_Start(&xip);
      while(!XNn_inference_IsDone(&xip)){}

  

      
      resv_mem.gather(result,100,1);
      RCLCPP_INFO(this->get_logger(), "result is %d",result[0]);
      std_msgs::msg::Int32 message=std_msgs::msg::Int32();
      message.data=result[0];
      publisher_->publish(message);

      this->thread_lock.unlock();
    }
};

int main(int argc, char * argv[])
{
  rclcpp::init(argc, argv);
  rclcpp::spin(std::make_shared<MinimalPublisher>());
  rclcpp::shutdown();
  return 0;
}