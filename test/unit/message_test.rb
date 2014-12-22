require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  setup do
    @message = messages(:one)
  end

  test "should not save message without title" do
    message = Message.new
    message.body = @message.body
    message.name = @message.name
    message.email = @message.email
    assert !message.save, "Saved the message without a title"
  end

  test "should not save message without name" do
    message = Message.new
    message.body = @message.body
    message.email = @message.email
    message.title = @message.title
    assert !message.save, "Saved the message without a name"
  end

  test "should not save message without email" do
    message = Message.new
    message.body = @message.body
    message.name = @message.name
    message.title = @message.title
    assert !message.save, "Saved the message without a email"
  end

  test "should not save message without body" do
    message = Message.new
    message.name = @message.name
    message.email = @message.email
    message.title = @message.title
    assert !message.save, "Saved the message without a body"
  end

  test "make sure state is unread" do
    message = Message.new
    assert message.state == "Unread"
  end

  test "should not save message with invalid email" do
    message = Message.new
    message.name = @message.name
    message.title = @message.title
    message.body = @message.body
    message.email = "??"
    assert !message.save, "Saved the message with an invalid email (without @)"
    message.email = "?@?@"
    assert !message.save, "Saved the message with an invalid email (2 or more @)"
    message.email = "@gmail.com"
    assert !message.save, "Saved the message with an invalid email (without local part)"
    message.email = "ssskenvipsss@"
    assert !message.save, "Saved the message with an invalid email (without domain part)"
    message.email = "sss sss@gmail.com"
    assert !message.save, "Saved the message with an invalid email (local part)"
    message.email = "ssskenvipsss@gmail..com"
    assert !message.save,
           "Saved the message with an invalid email (domain part: . appear two or more times consecutively)"
    message.email = "ssskenvipsss@.com"
    assert !message.save, "Saved the message with an invalid email (domain part: . appear after @)"
    message.email = "ssskenvipsss@gmail+.com"
    assert !message.save, "Saved the message with an invalid email (domain part: invalid character)"
    message.email = "ssskenvipsss@gmail.c"
    assert !message.save,
           "Saved the message with an invalid email(top-level domain following up a dot require minimum two alphabetic characters)"
  end
end
