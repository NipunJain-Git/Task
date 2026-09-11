"""Exercise the generated action and Python nodes through ROS 2."""

import threading
import time

from action_msgs.msg import GoalStatus
from custom_action_nodes.action_client import CountDownActionClient
from custom_action_nodes.action_server import CountDownActionServer
from custom_action_pkg.action import CountDown
import pytest
import rclpy
from rclpy.action import ActionClient
from rclpy.executors import MultiThreadedExecutor


def wait_for(future, timeout=10.0):
    """Wait for a future handled by the background executor."""
    deadline = time.monotonic() + timeout
    while not future.done() and time.monotonic() < deadline:
        time.sleep(0.01)
    assert future.done(), 'Timed out waiting for an action response'
    return future.result()


@pytest.fixture
def nodes():
    """Run server and client together and always release ROS resources."""
    rclpy.init()
    server = CountDownActionServer()
    client = CountDownActionClient()
    executor = MultiThreadedExecutor(num_threads=4)
    executor.add_node(server)
    executor.add_node(client)
    thread = threading.Thread(target=executor.spin, daemon=True)
    thread.start()
    try:
        yield server, client
    finally:
        executor.shutdown(timeout_sec=10.0)
        thread.join(timeout=10.0)
        client.destroy_node()
        server.destroy_node()
        rclpy.try_shutdown()


@pytest.mark.parametrize('target', [0, 2])
def test_countdown_feedback_and_result(nodes, target):
    """Count down inclusively to zero and return a successful result."""
    _, client = nodes
    action = ActionClient(client, CountDown, 'count_down')
    try:
        assert action.wait_for_server(timeout_sec=5.0)
        feedback = []
        handle = wait_for(action.send_goal_async(
            CountDown.Goal(target=target),
            feedback_callback=lambda msg: feedback.append(msg.feedback.current_count),
        ))
        assert handle.accepted
        response = wait_for(handle.get_result_async())
        assert response.status == GoalStatus.STATUS_SUCCEEDED
        assert response.result.status == 'Done!'
        deadline = time.monotonic() + 2.0
        while len(feedback) < target + 1 and time.monotonic() < deadline:
            time.sleep(0.01)
        assert feedback == list(range(target, -1, -1))
    finally:
        action.destroy()


def test_cancel_countdown(nodes):
    """Accept cancellation while the execution callback is sleeping."""
    _, client = nodes
    action = ActionClient(client, CountDown, 'count_down')
    try:
        assert action.wait_for_server(timeout_sec=5.0)
        started = threading.Event()
        handle = wait_for(action.send_goal_async(
            CountDown.Goal(target=5),
            feedback_callback=lambda msg: started.set(),
        ))
        assert handle.accepted
        assert started.wait(timeout=5.0)
        cancellation = wait_for(handle.cancel_goal_async())
        assert cancellation.goals_canceling
        response = wait_for(handle.get_result_async())
        assert response.status == GoalStatus.STATUS_CANCELED
        assert response.result.status == 'Canceled'
    finally:
        action.destroy()


@pytest.mark.parametrize('target, accepted', [(0, True), (-1, False)])
def test_client_finishes(nodes, target, accepted):
    """Finish the client both on success and when the server rejects a goal."""
    _, client = nodes
    client.send_goal(target)
    assert wait_for(client.done) is accepted


def test_client_finishes_without_server(nodes, monkeypatch):
    """Stop waiting when server discovery times out."""
    _, client = nodes
    monkeypatch.setattr(client._action_client, 'wait_for_server', lambda **kwargs: False)
    client.send_goal(0)
    assert wait_for(client.done) is False