# require 'time'
require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'


get '/' do
  meeting = Meeting.first
  p meeting
  p meeting.agendas.order('id')
  timer = MeetingTimer.new(meeting, meeting.agendas.order('id'))
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

class MeetingTimer
  attr_accessor :meeting, :agendas
  def initialize(meeting, agendas)
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
          puts "開始時刻:#{Time.at(@time).strftime('%H時%M分%S秒')}"
        end
        p 'start meeting'
        self.start_agenda(@agendas[@current_agenda_count])
      # beginの中が終わったら呼ばれる
      ensure
        p 'ensure create_meeting'
      end
    end
  end

  def start_agenda(agenda)
    p 'start agenda'
    p "agenda title: #{agenda.title}"
    @time += agenda.duration
    @thread = Thread.new do
      begin
        while Time.now.to_i <= @time
          sleep(1)
          puts "現在時刻:#{Time.now.strftime('%H時%M分%S秒')}"
          puts "開始時刻:#{Time.at(@time).strftime('%H時%M分%S秒')}"
        end
        finish_agenda()
      ensure
        p 'agenda ended'
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
          puts "開始時刻:#{Time.at(@time).strftime('%H時%M分%S秒')}"
        end
        finish_agenda()
      ensure
        p 'agenda ended'
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
    if @current_agenda_count == @agendas.length
      p 'meeting ended'
    else
      self.start_agenda(@agendas[@current_agenda_count])
    end
  end
  
  
  def finish_meeting(thread)
    if thread
      thread.kill
    else
      p 'Thread is not created'
    end
  end

end
