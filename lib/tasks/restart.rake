task :restart do
  system("touch tmp/restart.txt")
  if ENV["DEBUG"] == 'true'
    system("touch tmp/debug.txt")
    puts 'Please start the remote debugger now with "rdebug -c".'
  else
    system("rm -f tmp/debug.txt")
  end
end

task :debug do
  ENV["DEBUG"] = 'true'
  Rake.invoke :restart
end