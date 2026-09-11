"""Send a configurable countdown goal and print feedback and its result."""

import rclpy
from rclpy.action import ActionClient
from rclpy.executors import ExternalShutdownException
from rclpy.node import Node
from rclpy.task import Future

from custom_action_pkg.action import CountDown


class CountDownActionClient(Node):
    """Send one goal and signal completion without shutting down in callbacks."""

    def __init__(self):
        """Create the client and declare its target parameter."""
        super().__init__('count_down_action_client')
        self.declare_parameter('target', 10)
        self.done = Future()

        self._action_client = ActionClient(
            self,
            CountDown,
            'count_down'
        )

    def send_goal(self, target):
        """Wait for the server and send a countdown goal."""

        self.get_logger().info(
            f'Sending countdown goal: {target}'
        )

        if not self._action_client.wait_for_server(timeout_sec=10.0):
            self.get_logger().error('Countdown action server is unavailable')
            self.done.set_result(False)
            return

        goal_msg = CountDown.Goal()
        goal_msg.target = target

        send_goal_future = self._action_client.send_goal_async(
            goal_msg,
            feedback_callback=self.feedback_callback
        )

        send_goal_future.add_done_callback(
            self.goal_response_callback
        )

    def goal_response_callback(self, future):
        """Request the result of an accepted goal, or finish on rejection."""

        goal_handle = future.result()

        if not goal_handle.accepted:
            self.get_logger().info('Goal rejected')
            self.done.set_result(False)
            return

        self.get_logger().info('Goal accepted')

        result_future = goal_handle.get_result_async()

        result_future.add_done_callback(
            self.get_result_callback
        )

    def feedback_callback(self, feedback_msg):
        """Log the current countdown value."""

        current_count = feedback_msg.feedback.current_count

        self.get_logger().info(
            f'Feedback: {current_count}'
        )

    def get_result_callback(self, future):
        """Log the final result and finish the client."""

        result = future.result().result

        self.get_logger().info(
            f'Final result: {result.status}'
        )

        self.done.set_result(True)


def main(args=None):
    """Send the target parameter and clean up after completion or interruption."""

    rclpy.init(args=args)

    node = CountDownActionClient()

    try:
        target = node.get_parameter('target').value
        if not 0 <= target <= 2147483647:
            node.get_logger().error('target must be between 0 and 2147483647')
            return
        node.send_goal(target)
        rclpy.spin_until_future_complete(node, node.done)
    except (KeyboardInterrupt, ExternalShutdownException):
        pass
    finally:
        node.destroy_node()
        rclpy.try_shutdown()


if __name__ == '__main__':
    main()
