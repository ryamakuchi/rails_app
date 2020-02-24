namespace :unicorn do
  desc 'Start Unicorn'
  task :start do
    config = Rails.root.join('config', 'unicorn.rb')
    sh "unicorn -c #{config} -E development -D"
  end

  desc 'Stop Unicorn'
  task :stop do
    unicorn_signal :QUIT
  end

  desc 'Check Unicorn status'
  task :status do
    sh 'ps -ef | grep unicorn | grep -v grep'
  end

  desc 'Restart Unicorn with USR2'
  task :restart do
    unicorn_signal :USR2
  end

  desc 'Increment number of worker processes'
  task :increment do
    unicorn_signal :TTIN
  end

  desc 'Decrement number of worker processes'
  task :decrement do
    unicorn_signal :TTOU
  end

  desc 'Unicorn pstree (depends on pstree command)'
  task :pstree do
    sh "pstree '#{unicorn_pid}'"
  end

  # Helpers
  def unicorn_signal signal
    Process.kill signal, unicorn_pid
  end

  def unicorn_pid
    File.read(Rails.root.join('tmp', 'pids', 'unicorn.pid')).to_i
  rescue Errno::ENOENT
    raise 'Unicorn does not seem to be running'
  end
end
