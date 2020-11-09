# require 'time'
require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?


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

User.order('id').each do |user|
  print "#{user.id}"
end

=begin
  @param date 開始時刻(Unix時間)
=end

Class Thread
  def initialize(meeting, agendas, current_agenda_count)
    @meeting = meeting
    @agendas = agendas
    @thread = nil
    @current_agenda_count = 0
    # Unix時間
    @time = meeting.start
    self.create_meeting()
  end

  def create_meeting()
    @thread = Thread.new do
      begin
        while Time.now.to_i <= @time
          sleep(1)
          puts "現在時刻:#{Time.now.strftime('%H時%M分%S秒')}"
          puts "開始時刻:#{Time.at(date).strftime('%H時%M分%S秒')}"
        end
        p 'start meeting'
      # beginの中が終わったら呼ばれる
      ensure
        self.start_agenda(@agendas[@current_agenda_count])
        p 'This thread is killed'
      end
    end
  end

  def start_agenda(agenda)
    @time += agenda.duration
    @thread = Thread.new do
      begin
        while Time.now.to_i <= @time
          sleep(1)
          puts "現在時刻:#{Time.now.strftime('%H時%M分%S秒')}"
          puts "開始時刻:#{Time.at(date).strftime('%H時%M分%S秒')}"
        end
        finish_agenda()
      ensure
        p 'This thread is killed'
      end
    end
  end
  
  def delay_agenda(time)
    p 'delay_agenda'
    @time += time
    @thread.kill
    @thread = Thread.new do
      begin
        while Time.now.to_i <= @time
          sleep(1)
          puts "現在時刻:#{Time.now.strftime('%H時%M分%S秒')}"
          puts "開始時刻:#{Time.at(date).strftime('%H時%M分%S秒')}"
        end
        finish_agenda()
      ensure
        p 'This thread is killed'
      end
    end
    self.start_agenda(@agendas[@current_agenda_count])
  end
  
  def terminate_agenda
    p 'terminate agenda'
    @thread.kill
    finish_agenda()
  end

  def finish_agenda
    @current_agenda_count += 1
    self.start_agenda(@agendas[@current_agenda_count])
  end
  
  
  def finish_meeting(thread)
    if thread
      thread.kill
    else
      p 'Thread is not created'
    end
  end
end
