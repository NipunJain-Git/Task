// generated from rosidl_generator_cpp/resource/idl__builder.hpp.em
// with input from custom_action_pkg:action/CountDown.idl
// generated code does not contain a copyright notice

#ifndef CUSTOM_ACTION_PKG__ACTION__DETAIL__COUNT_DOWN__BUILDER_HPP_
#define CUSTOM_ACTION_PKG__ACTION__DETAIL__COUNT_DOWN__BUILDER_HPP_

#include <algorithm>
#include <utility>

#include "custom_action_pkg/action/detail/count_down__struct.hpp"
#include "rosidl_runtime_cpp/message_initialization.hpp"


namespace custom_action_pkg
{

namespace action
{

namespace builder
{

class Init_CountDown_Goal_target
{
public:
  Init_CountDown_Goal_target()
  : msg_(::rosidl_runtime_cpp::MessageInitialization::SKIP)
  {}
  ::custom_action_pkg::action::CountDown_Goal target(::custom_action_pkg::action::CountDown_Goal::_target_type arg)
  {
    msg_.target = std::move(arg);
    return std::move(msg_);
  }

private:
  ::custom_action_pkg::action::CountDown_Goal msg_;
};

}  // namespace builder

}  // namespace action

template<typename MessageType>
auto build();

template<>
inline
auto build<::custom_action_pkg::action::CountDown_Goal>()
{
  return custom_action_pkg::action::builder::Init_CountDown_Goal_target();
}

}  // namespace custom_action_pkg


namespace custom_action_pkg
{

namespace action
{

namespace builder
{

class Init_CountDown_Result_status
{
public:
  Init_CountDown_Result_status()
  : msg_(::rosidl_runtime_cpp::MessageInitialization::SKIP)
  {}
  ::custom_action_pkg::action::CountDown_Result status(::custom_action_pkg::action::CountDown_Result::_status_type arg)
  {
    msg_.status = std::move(arg);
    return std::move(msg_);
  }

private:
  ::custom_action_pkg::action::CountDown_Result msg_;
};

}  // namespace builder

}  // namespace action

template<typename MessageType>
auto build();

template<>
inline
auto build<::custom_action_pkg::action::CountDown_Result>()
{
  return custom_action_pkg::action::builder::Init_CountDown_Result_status();
}

}  // namespace custom_action_pkg


namespace custom_action_pkg
{

namespace action
{

namespace builder
{

class Init_CountDown_Feedback_current_count
{
public:
  Init_CountDown_Feedback_current_count()
  : msg_(::rosidl_runtime_cpp::MessageInitialization::SKIP)
  {}
  ::custom_action_pkg::action::CountDown_Feedback current_count(::custom_action_pkg::action::CountDown_Feedback::_current_count_type arg)
  {
    msg_.current_count = std::move(arg);
    return std::move(msg_);
  }

private:
  ::custom_action_pkg::action::CountDown_Feedback msg_;
};

}  // namespace builder

}  // namespace action

template<typename MessageType>
auto build();

template<>
inline
auto build<::custom_action_pkg::action::CountDown_Feedback>()
{
  return custom_action_pkg::action::builder::Init_CountDown_Feedback_current_count();
}

}  // namespace custom_action_pkg


namespace custom_action_pkg
{

namespace action
{

namespace builder
{

class Init_CountDown_SendGoal_Request_goal
{
public:
  explicit Init_CountDown_SendGoal_Request_goal(::custom_action_pkg::action::CountDown_SendGoal_Request & msg)
  : msg_(msg)
  {}
  ::custom_action_pkg::action::CountDown_SendGoal_Request goal(::custom_action_pkg::action::CountDown_SendGoal_Request::_goal_type arg)
  {
    msg_.goal = std::move(arg);
    return std::move(msg_);
  }

private:
  ::custom_action_pkg::action::CountDown_SendGoal_Request msg_;
};

class Init_CountDown_SendGoal_Request_goal_id
{
public:
  Init_CountDown_SendGoal_Request_goal_id()
  : msg_(::rosidl_runtime_cpp::MessageInitialization::SKIP)
  {}
  Init_CountDown_SendGoal_Request_goal goal_id(::custom_action_pkg::action::CountDown_SendGoal_Request::_goal_id_type arg)
  {
    msg_.goal_id = std::move(arg);
    return Init_CountDown_SendGoal_Request_goal(msg_);
  }

private:
  ::custom_action_pkg::action::CountDown_SendGoal_Request msg_;
};

}  // namespace builder

}  // namespace action

template<typename MessageType>
auto build();

template<>
inline
auto build<::custom_action_pkg::action::CountDown_SendGoal_Request>()
{
  return custom_action_pkg::action::builder::Init_CountDown_SendGoal_Request_goal_id();
}

}  // namespace custom_action_pkg


namespace custom_action_pkg
{

namespace action
{

namespace builder
{

class Init_CountDown_SendGoal_Response_stamp
{
public:
  explicit Init_CountDown_SendGoal_Response_stamp(::custom_action_pkg::action::CountDown_SendGoal_Response & msg)
  : msg_(msg)
  {}
  ::custom_action_pkg::action::CountDown_SendGoal_Response stamp(::custom_action_pkg::action::CountDown_SendGoal_Response::_stamp_type arg)
  {
    msg_.stamp = std::move(arg);
    return std::move(msg_);
  }

private:
  ::custom_action_pkg::action::CountDown_SendGoal_Response msg_;
};

class Init_CountDown_SendGoal_Response_accepted
{
public:
  Init_CountDown_SendGoal_Response_accepted()
  : msg_(::rosidl_runtime_cpp::MessageInitialization::SKIP)
  {}
  Init_CountDown_SendGoal_Response_stamp accepted(::custom_action_pkg::action::CountDown_SendGoal_Response::_accepted_type arg)
  {
    msg_.accepted = std::move(arg);
    return Init_CountDown_SendGoal_Response_stamp(msg_);
  }

private:
  ::custom_action_pkg::action::CountDown_SendGoal_Response msg_;
};

}  // namespace builder

}  // namespace action

template<typename MessageType>
auto build();

template<>
inline
auto build<::custom_action_pkg::action::CountDown_SendGoal_Response>()
{
  return custom_action_pkg::action::builder::Init_CountDown_SendGoal_Response_accepted();
}

}  // namespace custom_action_pkg


namespace custom_action_pkg
{

namespace action
{

namespace builder
{

class Init_CountDown_GetResult_Request_goal_id
{
public:
  Init_CountDown_GetResult_Request_goal_id()
  : msg_(::rosidl_runtime_cpp::MessageInitialization::SKIP)
  {}
  ::custom_action_pkg::action::CountDown_GetResult_Request goal_id(::custom_action_pkg::action::CountDown_GetResult_Request::_goal_id_type arg)
  {
    msg_.goal_id = std::move(arg);
    return std::move(msg_);
  }

private:
  ::custom_action_pkg::action::CountDown_GetResult_Request msg_;
};

}  // namespace builder

}  // namespace action

template<typename MessageType>
auto build();

template<>
inline
auto build<::custom_action_pkg::action::CountDown_GetResult_Request>()
{
  return custom_action_pkg::action::builder::Init_CountDown_GetResult_Request_goal_id();
}

}  // namespace custom_action_pkg


namespace custom_action_pkg
{

namespace action
{

namespace builder
{

class Init_CountDown_GetResult_Response_result
{
public:
  explicit Init_CountDown_GetResult_Response_result(::custom_action_pkg::action::CountDown_GetResult_Response & msg)
  : msg_(msg)
  {}
  ::custom_action_pkg::action::CountDown_GetResult_Response result(::custom_action_pkg::action::CountDown_GetResult_Response::_result_type arg)
  {
    msg_.result = std::move(arg);
    return std::move(msg_);
  }

private:
  ::custom_action_pkg::action::CountDown_GetResult_Response msg_;
};

class Init_CountDown_GetResult_Response_status
{
public:
  Init_CountDown_GetResult_Response_status()
  : msg_(::rosidl_runtime_cpp::MessageInitialization::SKIP)
  {}
  Init_CountDown_GetResult_Response_result status(::custom_action_pkg::action::CountDown_GetResult_Response::_status_type arg)
  {
    msg_.status = std::move(arg);
    return Init_CountDown_GetResult_Response_result(msg_);
  }

private:
  ::custom_action_pkg::action::CountDown_GetResult_Response msg_;
};

}  // namespace builder

}  // namespace action

template<typename MessageType>
auto build();

template<>
inline
auto build<::custom_action_pkg::action::CountDown_GetResult_Response>()
{
  return custom_action_pkg::action::builder::Init_CountDown_GetResult_Response_status();
}

}  // namespace custom_action_pkg


namespace custom_action_pkg
{

namespace action
{

namespace builder
{

class Init_CountDown_FeedbackMessage_feedback
{
public:
  explicit Init_CountDown_FeedbackMessage_feedback(::custom_action_pkg::action::CountDown_FeedbackMessage & msg)
  : msg_(msg)
  {}
  ::custom_action_pkg::action::CountDown_FeedbackMessage feedback(::custom_action_pkg::action::CountDown_FeedbackMessage::_feedback_type arg)
  {
    msg_.feedback = std::move(arg);
    return std::move(msg_);
  }

private:
  ::custom_action_pkg::action::CountDown_FeedbackMessage msg_;
};

class Init_CountDown_FeedbackMessage_goal_id
{
public:
  Init_CountDown_FeedbackMessage_goal_id()
  : msg_(::rosidl_runtime_cpp::MessageInitialization::SKIP)
  {}
  Init_CountDown_FeedbackMessage_feedback goal_id(::custom_action_pkg::action::CountDown_FeedbackMessage::_goal_id_type arg)
  {
    msg_.goal_id = std::move(arg);
    return Init_CountDown_FeedbackMessage_feedback(msg_);
  }

private:
  ::custom_action_pkg::action::CountDown_FeedbackMessage msg_;
};

}  // namespace builder

}  // namespace action

template<typename MessageType>
auto build();

template<>
inline
auto build<::custom_action_pkg::action::CountDown_FeedbackMessage>()
{
  return custom_action_pkg::action::builder::Init_CountDown_FeedbackMessage_goal_id();
}

}  // namespace custom_action_pkg

#endif  // CUSTOM_ACTION_PKG__ACTION__DETAIL__COUNT_DOWN__BUILDER_HPP_
