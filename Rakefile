# This Rakefile comes from the Jekyll orderofeverything.com

desc "watch coffee and sass files"
task :default do
  pids = [
    spawn("compass watch"), # -s compressed
    spawn("coffee -b -w -o javascripts -c src/*.coffee")
  ]

  trap "INT" do
    Process.kill "INT", *pids
    exit 1
  end

  loop do
    sleep 1
  end
end
