// generated from rosidl_generator_c/resource/idl__struct.h.em
// with input from custom_action_pkg:action/CountDown.idl
// generated code does not contain a copyright notice

#ifndef CUSTOM_ACTION_PKG__ACTION__DETAIL__COUNT_DOWN__STRUCT_H_
#define CUSTOM_ACTION_PKG__ACTION__DETAIL__COUNT_DOWN__STRUCT_H_

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>


// Constants defined in the message

/// Struct defined in action/CountDown in the package custom_action_pkg.
typedef struct custom_action_pkg__action__CountDown_Goal
{
  int32_t target;
} custom_action_pkg__action__CountDown_Goal;

// Struct for a sequence of custom_action_pkg__action__CountDown_Goal.
typedef struct custom_action_pkg__action__CountDown_Goal__Sequence
{
  custom_action_pkg__action__CountDown_Goal * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} custom_action_pkg__action__CountDown_Goal__Sequence;


// Constants defined in the message

// Include directives for member types
// Member 'status'
#include "rosidl_runtime_c/string.h"

/// Struct defined in action/CountDown in the package custom_action_pkg.
typedef struct custom_action_pkg__action__CountDown_Result
{
  rosidl_runtime_c__String status;
} custom_action_pkg__action__CountDown_Result;

// Struct for a sequence of custom_action_pkg__action__CountDown_Result.
typedef struct custom_action_pkg__action__CountDown_Result__Sequence
{
  custom_action_pkg__action__CountDown_Result * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} custom_action_pkg__action__CountDown_Result__Sequence;


// Constants defined in the message

/// Struct defined in action/CountDown in the package custom_action_pkg.
typedef struct custom_action_pkg__action__CountDown_Feedback
{
  int32_t current_count;
} custom_action_pkg__action__CountDown_Feedback;

// Struct for a sequence of custom_action_pkg__action__CountDown_Feedback.
typedef struct custom_action_pkg__action__CountDown_Feedback__Sequence
{
  custom_action_pkg__action__CountDown_Feedback * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} custom_action_pkg__action__CountDown_Feedback__Sequence;


// Constants defined in the message

// Include directives for member types
// Member 'goal_id'
#include "unique_identifier_msgs/msg/detail/uuid__struct.h"
// Member 'goal'
#include "custom_action_pkg/action/detail/count_down__struct.h"

/// Struct defined in action/CountDown in the package custom_action_pkg.
typedef struct custom_action_pkg__action__CountDown_SendGoal_Request
{
  unique_identifier_msgs__msg__UUID goal_id;
  custom_action_pkg__action__CountDown_Goal goal;
} custom_action_pkg__action__CountDown_SendGoal_Request;

// Struct for a sequence of custom_action_pkg__action__CountDown_SendGoal_Request.
typedef struct custom_action_pkg__action__CountDown_SendGoal_Request__Sequence
{
  custom_action_pkg__action__CountDown_SendGoal_Request * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} custom_action_pkg__action__CountDown_SendGoal_Request__Sequence;


// Constants defined in the message

// Include directives for member types
// Member 'stamp'
#include "builtin_interfaces/msg/detail/time__struct.h"

/// Struct defined in action/CountDown in the package custom_action_pkg.
typedef struct custom_action_pkg__action__CountDown_SendGoal_Response
{
  bool accepted;
  builtin_interfaces__msg__Time stamp;
} custom_action_pkg__action__CountDown_SendGoal_Response;

// Struct for a sequence of custom_action_pkg__action__CountDown_SendGoal_Response.
typedef struct custom_action_pkg__action__CountDown_SendGoal_Response__Sequence
{
  custom_action_pkg__action__CountDown_SendGoal_Response * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} custom_action_pkg__action__CountDown_SendGoal_Response__Sequence;


// Constants defined in the message

// Include directives for member types
// Member 'goal_id'
// already included above
// #include "unique_identifier_msgs/msg/detail/uuid__struct.h"

/// Struct defined in action/CountDown in the package custom_action_pkg.
typedef struct custom_action_pkg__action__CountDown_GetResult_Request
{
  unique_identifier_msgs__msg__UUID goal_id;
} custom_action_pkg__action__CountDown_GetResult_Request;

// Struct for a sequence of custom_action_pkg__action__CountDown_GetResult_Request.
typedef struct custom_action_pkg__action__CountDown_GetResult_Request__Sequence
{
  custom_action_pkg__action__CountDown_GetResult_Request * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} custom_action_pkg__action__CountDown_GetResult_Request__Sequence;


// Constants defined in the message

// Include directives for member types
// Member 'result'
// already included above
// #include "custom_action_pkg/action/detail/count_down__struct.h"

/// Struct defined in action/CountDown in the package custom_action_pkg.
typedef struct custom_action_pkg__action__CountDown_GetResult_Response
{
  int8_t status;
  custom_action_pkg__action__CountDown_Result result;
} custom_action_pkg__action__CountDown_GetResult_Response;

// Struct for a sequence of custom_action_pkg__action__CountDown_GetResult_Response.
typedef struct custom_action_pkg__action__CountDown_GetResult_Response__Sequence
{
  custom_action_pkg__action__CountDown_GetResult_Response * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} custom_action_pkg__action__CountDown_GetResult_Response__Sequence;


// Constants defined in the message

// Include directives for member types
// Member 'goal_id'
// already included above
// #include "unique_identifier_msgs/msg/detail/uuid__struct.h"
// Member 'feedback'
// already included above
// #include "custom_action_pkg/action/detail/count_down__struct.h"

/// Struct defined in action/CountDown in the package custom_action_pkg.
typedef struct custom_action_pkg__action__CountDown_FeedbackMessage
{
  unique_identifier_msgs__msg__UUID goal_id;
  custom_action_pkg__action__CountDown_Feedback feedback;
} custom_action_pkg__action__CountDown_FeedbackMessage;

// Struct for a sequence of custom_action_pkg__action__CountDown_FeedbackMessage.
typedef struct custom_action_pkg__action__CountDown_FeedbackMessage__Sequence
{
  custom_action_pkg__action__CountDown_FeedbackMessage * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} custom_action_pkg__action__CountDown_FeedbackMessage__Sequence;

#ifdef __cplusplus
}
#endif

#endif  // CUSTOM_ACTION_PKG__ACTION__DETAIL__COUNT_DOWN__STRUCT_H_
