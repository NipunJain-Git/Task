import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Vector3
from std_msgs.msg import String


class MinimalSubscriber(Node):

    def __init__(self):
        super().__init__('minimal_subscriber')
        self.subscription = self.create_subscription(Vector3, 'sensor_data', self.listener_callback, 10)
        self.pusblisher_=self.create_publisher(String,'topic',10)
        self.subscription  # prevent unused variable warning

    def listener_callback(self, msg):
        x=msg.x
        y=msg.y
        z=msg.z
        avg=(x+y+z)/3
        msg=String()
        msg.data=f'average={avg}'
        self.pusblisher_.publish(msg)
        self.get_logger().info(f'I heard: average={avg}')


def main(args=None):
    rclpy.init(args=args)

    minimal_subscriber = MinimalSubscriber()

    rclpy.spin(minimal_subscriber)

    # Destroy the node explicitly
    # (optional - otherwise it will be done automatically
    # when the garbage collector destroys the node object)
    minimal_subscriber.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()