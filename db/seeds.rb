meeting = Meeting.create!(
  random_num: 'test',
  title: 'test_meeting',
  start: Time.now.to_i + 60,
)

5.times do |i|
  Agenda.create!(
    meeting_id: meeting.id,
    title: "topic_#{i}",
    duration: 5,
  )
end