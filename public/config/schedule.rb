# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#

every 120.minutes do
  runner "CronJob.save_article_page_view", :output => 'log/cronjob_page_view.log'
end

every 1.day, :at => "9:30 pm" do
  runner "CronJob.send_newsletter", :output => 'log/cronjob_newsletter.log'
end

# Learn more: http://github.com/javan/whenever
