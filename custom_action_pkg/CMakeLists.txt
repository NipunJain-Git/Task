cmake_minimum_required(VERSION 3.8)
project(custom_action_pkg)

find_package(ament_cmake REQUIRED)
find_package(ament_cmake_python REQUIRED)
find_package(rosidl_default_generators REQUIRED)
find_package(action_msgs REQUIRED)

rosidl_generate_interfaces(${PROJECT_NAME}
  "action/CountDown.action"
  DEPENDENCIES action_msgs
)

# The generated interfaces already install the custom_action_pkg Python package.
ament_python_install_package(custom_action_nodes)
ament_export_dependencies(rosidl_default_runtime)

install(
  PROGRAMS
    ${CMAKE_CURRENT_SOURCE_DIR}/scripts/action_server
    ${CMAKE_CURRENT_SOURCE_DIR}/scripts/action_client
  DESTINATION lib/${PROJECT_NAME}
)

install(
  DIRECTORY launch
  DESTINATION share/${PROJECT_NAME}
)

if(BUILD_TESTING)
  find_package(ament_cmake_pytest REQUIRED)
  ament_add_pytest_test(count_down_tests test
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    TIMEOUT 60
  )
endif()

ament_package()
