#include <chrono>
#include <functional>
#include <memory>
#include <string>
#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>

#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"
#include "std_msgs/msg/int32.hpp"
#include "dynamixel_sdk_custom_interfaces/msg/set_position.hpp"
#include "dynamixel_sdk_custom_interfaces/srv/get_position.hpp"

using namespace std::chrono_literals;
using SetPosition = dynamixel_sdk_custom_interfaces::msg::SetPosition;
using GetPosition = dynamixel_sdk_custom_interfaces::srv::GetPosition;

/* This example creates a subclass of Node and uses std::bind() to register a
* member function as a callback from the timer. */

class MinimalPublisher : public rclcpp::Node
{
  public:
    MinimalPublisher(): Node("minimal_publisher"), index(0), running(false)
    {
      RCLCPP_INFO(this->get_logger(), "Starting listening for '/set_draw_number'");
      publisher_ = this->create_publisher<SetPosition>("/set_position", 10);
      subscription_ = this->create_subscription<std_msgs::msg::Int32>(
      "/set_draw_number", 10, std::bind(&MinimalPublisher::set_number_callback, this,std::placeholders::_1));
      timer_ = this->create_wall_timer(50ms, std::bind(&MinimalPublisher::timer_callback, this));

      draw_command_sub = this->create_subscription<std_msgs::msg::Int32>(
        "/can_i_draw",10,std::bind(&MinimalPublisher::can_i_draw_callback,this,std::placeholders::_1));
    }

  private:
    void ReadFile(std::string file_name){
        std::ifstream file(file_name);
        if (!file.is_open()) {
            std::cerr << "Error opening file" << std::endl;
            return;
        }

        
        std::string line, cell;

        while (std::getline(file, line)) {
            std::vector<float> row;
            std::stringstream lineStream(line);

            while (std::getline(lineStream, cell, ',')) {
                row.push_back(std::stof(cell));
            }

            this->path.push_back(row);
        }

        file.close();
    }

    void timer_callback()
    {
      this->thread_lock.lock();
      if(this->running and can_i_draw == true){
        std::vector<float> new_pos=this->path[index];
        auto message = SetPosition();
        float angle0=new_pos[0];
        float angle1=new_pos[1];
        float pos0=(angle0+60)*1023/300;
        float pos1=(angle1+60)*1023/300;
        RCLCPP_INFO(this->get_logger(), "Publishing starting position %d %d", (int)angle0,(int)angle1);
        
        message.id=0;
        message.position=(int)pos0;
        publisher_->publish(message);

        message.id=1;
        message.position=(int)pos1;
        publisher_->publish(message);

        this->index++;
        if (this->index>this->path.size()-1){
          this->running=false;
          this->timer_->cancel();
          can_i_draw = false;
        }
      }
      this->thread_lock.unlock();
    }

    void set_number_callback(const std_msgs::msg::Int32::SharedPtr msg)
    {
      this->thread_lock.lock();
      RCLCPP_INFO(this->get_logger(), "Received Draw Number: '%d'", msg->data);
      if(!running){
        std::string file_path="";
        switch(msg->data){
          case 0:
          file_path="path_files/0.csv";
            break;
          case 1:
          file_path="path_files/1.csv";
            break;
          case 2:
          file_path="path_files/2.csv";
            break;
          case 3:
          file_path="path_files/3.csv";
            break;
          case 4:
          file_path="path_files/4.csv";
            break;
          case 5:
          file_path="path_files/5.csv";
            break;
          case 6:
          file_path="path_files/6.csv";
            break;
          case 7:
          file_path="path_files/7.csv";
            break;
          case 8:
          file_path="path_files/8.csv";
            break;
          case 9:
          file_path="path_files/9.csv";
            break;
          case 26:
          file_path="path_files/26.csv";
            break;
        }
        if(file_path!=""){
          this->ReadFile(file_path);
          this->running=true;
          this->timer_->reset();
        }else if(msg->data==-1){
          auto message = SetPosition();
          int angle0=118;
          int angle1=61;
          int pos0=(angle0+60)*1023/300;
          int pos1=(angle1+60)*1023/300;
          RCLCPP_INFO(this->get_logger(), "Resetting to starting position %d %d", angle0,angle1);
        
          message.id=0;
          message.position=pos0;
          publisher_->publish(message);
        }

      }
      this->thread_lock.unlock();
    }

    void can_i_draw_callback(const std_msgs::msg::Int32::SharedPtr msg){
      if(msg->data==1){
        can_i_draw = true;
      }
      else{
        can_i_draw = false;}
    }
    std::vector<std::vector<float>> path;
    size_t index;
    bool running;
    std::mutex thread_lock;
    bool can_i_draw = false;
    



    rclcpp::TimerBase::SharedPtr timer_;
    rclcpp::Publisher<SetPosition>::SharedPtr publisher_;
    rclcpp::Subscription<std_msgs::msg::Int32>::SharedPtr subscription_;
    rclcpp::Subscription<std_msgs::msg::Int32>::SharedPtr draw_command_sub;
};

int main(int argc, char * argv[])
{
  rclcpp::init(argc, argv);
  rclcpp::spin(std::make_shared<MinimalPublisher>());
  rclcpp::shutdown();
  return 0;
}