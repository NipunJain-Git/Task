# generated from rosidl_cmake/cmake/rosidl_cmake_aggregate_target-extras.cmake.in

# Create a convenience aggregate target custom_action_pkg::custom_action_pkg
# that links all generated interface targets, so downstream packages can use
# a single modern CMake target name instead of ${custom_action_pkg_TARGETS}.
if(custom_action_pkg_TARGETS AND NOT TARGET custom_action_pkg::custom_action_pkg)
  add_library(custom_action_pkg::custom_action_pkg INTERFACE IMPORTED)
  set_target_properties(custom_action_pkg::custom_action_pkg PROPERTIES
    INTERFACE_LINK_LIBRARIES "${custom_action_pkg_TARGETS}")
endif()
