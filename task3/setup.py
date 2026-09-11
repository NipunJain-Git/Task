from setuptools import find_packages, setup

package_name = 'task3'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='nipun',
    maintainer_email='nipun256h@gmail.com',
    description='task3',
    license='Apache License 2.0',
    extras_require={
        'test': [
            'pytest',
        ],
    },
    entry_points={
        'console_scripts': [
        	'service = task3.service_member_function:main',
        	'client = task3.client_member_function:main',
        ],
    },
)
