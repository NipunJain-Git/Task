"""Launch the countdown server and a client with a configurable target."""

from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node
from launch_ros.parameter_descriptions import ParameterValue


def generate_launch_description():
    """Start both countdown nodes."""

    return LaunchDescription([
        DeclareLaunchArgument('target', default_value='10'),

        Node(
            package='custom_action_pkg',
            executable='action_server',
            name='count_down_server',
            output='screen'
        ),

        Node(
            package='custom_action_pkg',
            executable='action_client',
            name='count_down_client',
            parameters=[{
                'target': ParameterValue(LaunchConfiguration('target'), value_type=int),
            }],
            output='screen'
        ),

    ])
