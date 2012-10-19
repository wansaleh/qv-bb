# The default, if you just run `rake` in this directory, will list all the available tasks
task :default do
  puts "Run watcher/livereload"
  run_task "watch"
end

desc "Start watcher"
task :watch do
  commander 'powder restart', 'compass watch 2>/dev/null', 'bundle exec guard'
end

desc "Start guard"
task :guard do
  commander 'guard'
end

desc "Uglifyjs"
task :uglify do
  require "uglifier"

  ["libs", "plugins"].each do |dir|
    min_dir = "public/assets/js/#{dir}-min"
    mkdir min_dir if !File.directory?(min_dir)
    Dir["public/assets/js/#{dir}/*.js"].each do |js|
      filename = File.basename(js)
      minified = Uglifier.compile(File.read(js), :copyright => false)
      File.open(File.join(min_dir, filename), 'w') do |f|
        f.write minified
      end
      puts "Uglified #{filename}!"
    end
  end
end

task :w => :watch
task :g => :guard
task :u => :uglify


# run command(s) and capture SIGINT
def commander(*cmds)
  pids = cmds.map { |cmd| Process.spawn("#{cmd}") }

  trap('INT') {
    pids.each { |pid| Process.kill(9, pid) rescue Errno::ESRCH }
    puts '==> Stopped!'
    exit 0
  }
  pids.each { |pid| Process.wait(pid) }
end

# rerun rake task
def run_task(*tasks)
  tasks.each do |task|
    Rake::Task[task].reenable
    Rake::Task[task].invoke
  end
end
