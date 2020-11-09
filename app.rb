# require 'time'
require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
# meeting = {
#   kickoff_date: 1604899502
#   agendas: [
#     {
#       duration: 300
#       topic_title: "議題A"
#     },
#     {
#       duration: 300
#       topic_title: "議題B"
#     },
#     {
#       duration: 300
#       topic_title: "議題C"
#     },
#     {
#       duration: 300
#       topic_title: "議題D"
#     },
#     {
#       duration: 300
#       topic_title: "議題E"
#     },
#   ]
# }
# threadを登録
thread = nil
# 現在のアジェンダが何個目か
current_agenda_count

get '/' do
  thread = create_meeting(Time.now.to_i + 10)
  '
  Timer started
  <a href="/stop">stop</a>
  '
end

get '/stop' do
  finish_meeting(thread)
  '
  Timer stopped
  <a href="/">start timer</a>
  '
end

=begin
  @param date 開始時刻(Unix時間)
=end
def create_meeting(date)
  Thread.new do
    begin
      while Time.now.to_i <= date
        sleep(1)
        puts "現在時刻:#{Time.now.strftime('%H時%M分%S秒')}"
        puts "開始時刻:#{Time.at(date).strftime('%H時%M分%S秒')}"
      end
      # １つ目のagenda用の画像生成をおこなう
      puts 'meeting start!'
    ensure
      p 'This thread is killed'
    end
  end
end

def start_agenda
  p 'start_agenda'
end

def delay_agenda
  p 'delay_agenda'
end

def end_agenda
  p 'end'
end


def finish_meeting(thread)
  if thread
    thread.kill
  else
    p 'Thread is not created'
  end
end

