import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Vector3
import random


class Sensornode(Node):

    def __init__(self):
        super().__init__('sensor_node')
        self.publisher_ = self.create_publisher(Vector3, 'sensor_data', 10)
        timer_period = 0.5  # 2Hz-0.5
        self.timer = self.create_timer(timer_period, self.publish_data)
        self.i = 0
        
    def publish_data(self):
        msg = Vector3()
        msg.x = random.uniform(0, 1024)
        msg.y = random.uniform(0, 1024)
        msg.z = random.uniform(0, 1024)
        self.publisher_.publish(msg)
        self.get_logger().info(f'Published: x={msg.x:.2f} y={msg.y:.2f} z={msg.z:.2f}')


def main(args=None):
    rclpy.init(args=args)

    node = Sensornode()

    rclpy.spin(node)

    # Destroy the node explicitly
    # (optional - otherwise it will be done automatically
    # when the garbage collector destroys the node object)
    node.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()
