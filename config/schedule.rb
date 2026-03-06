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
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :environment, 'development'
set :output, '/home/xprolabs/www/linked_in_demo/log/cron.log'
set :bundle_command, '/home/xprolabs/.rbenv/shims/bundle exec'
set :rails_env, 'development'

cron '0 1 * * *' do
  runner "CloseExpiredJobsJob.perform_later"
end

cron '0 9 * * 1' do
  runner "WeeklyDigestJob.perform_later"
end

cron '0 2 * * *' do
  runner "NightlyReindexJob.perform_later"
end
