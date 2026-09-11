"""Serve countdown goals and publish feedback once per second."""

import time

import rclpy
from rclpy.action import ActionServer, CancelResponse, GoalResponse
from rclpy.callback_groups import ReentrantCallbackGroup
from rclpy.executors import ExternalShutdownException, MultiThreadedExecutor
from rclpy.node import Node

from custom_action_pkg.action import CountDown


class CountDownActionServer(Node):
    """Execute nonnegative countdown goals with cancellation support."""

    def __init__(self):
        """Create the action server."""
        super().__init__('count_down_action_server')

        self._action_server = ActionServer(
            self,
            CountDown,
            'count_down',
            self.execute_callback,
            callback_group=ReentrantCallbackGroup(),
            goal_callback=self.goal_callback,
            cancel_callback=self.cancel_callback,
        )

        self.get_logger().info('Countdown Action Server started')

    def goal_callback(self, goal_request):
        """Reject targets below zero."""
        if goal_request.target < 0:
            self.get_logger().warning('Countdown target must be nonnegative')
            return GoalResponse.REJECT
        return GoalResponse.ACCEPT

    def cancel_callback(self, goal_handle):
        """Allow an active countdown to be canceled."""
        return CancelResponse.ACCEPT

    def execute_callback(self, goal_handle):
        """Publish each count and return a terminal result."""
        self.get_logger().info(
            f'Received goal: {goal_handle.request.target}'
        )

        target = goal_handle.request.target

        feedback_msg = CountDown.Feedback()

        for count in range(target, -1, -1):

            if not rclpy.ok(context=self.context):
                goal_handle.abort()
                result = CountDown.Result()
                result.status = 'Server shutting down'
                return result

            if goal_handle.is_cancel_requested:
                goal_handle.canceled()
                result = CountDown.Result()
                result.status = 'Canceled'
                return result

            feedback_msg.current_count = count
            goal_handle.publish_feedback(feedback_msg)

            self.get_logger().info(f'Counting: {count}')

            if count > 0:
                time.sleep(1)

        goal_handle.succeed()

        result = CountDown.Result()
        result.status = 'Done!'

        self.get_logger().info('Countdown completed')

        return result


def main(args=None):
    """Run callbacks concurrently so cancellation can interrupt execution."""
    rclpy.init(args=args)

    node = CountDownActionServer()
    executor = MultiThreadedExecutor(num_threads=4)
    executor.add_node(node)
    try:
        executor.spin()
    except (KeyboardInterrupt, ExternalShutdownException):
        pass
    finally:
        rclpy.try_shutdown()
        executor.shutdown()
        node.destroy_node()


if __name__ == '__main__':
    main()
