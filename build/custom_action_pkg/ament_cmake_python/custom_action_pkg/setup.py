from setuptools import find_packages
from setuptools import setup

setup(
    name='custom_action_pkg',
    version='0.0.0',
    packages=find_packages(
        include=('custom_action_pkg', 'custom_action_pkg.*')),
)
