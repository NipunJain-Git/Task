from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(package='sensor_pipeline', executable='sensor_node', name='sensor_node'),
        Node(package='sensor_pipeline', executable='processor_node', name='processor_node'),
        Node(package='sensor_pipeline', executable='logger_node', name='logger_node'),
    ])
