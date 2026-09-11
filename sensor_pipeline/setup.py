from setuptools import find_packages, setup

package_name = 'sensor_pipeline'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
        ('share/' + package_name + '/launch',
            ['launch/sensor_pipeline.launch.py']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='nipun',
    maintainer_email='nipun256h@gmail.com',
    description='Task1',
    license='Apache-2.0',
    extras_require={
        'test': [
            'pytest',
        ],
    },
    entry_points={
        'console_scripts': [
            'sensor_node = sensor_pipeline_nodes.SensorNode:main',
            'processor_node = sensor_pipeline_nodes.ProcessorNode:main',
            'logger_node = sensor_pipeline_nodes.LoggerNode:main',
        ],
},
)
