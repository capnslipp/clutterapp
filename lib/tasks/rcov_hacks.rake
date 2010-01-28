require 'rake'

namespace :spec do
  namespace :rcov do
    
    desc "Run spec:rcov, then open the resulting HTML files in the browser"
    task :browser do
      Rake::Task['spec:rcov'].execute
      
      system('open coverage/index.html')
    end
    
  end
end



#namespace :test do
#  desc 'Measures test coverage'
#  task :coverage do
#    rm_f "coverage"
#    rm_f "coverage.data"
#    rcov = "rcov -Itest --rails --aggregate coverage.data -T -x \" rubygems/*,/Library/Ruby/Site/*,gems/*,rcov*\""
#    system("#{rcov} --no-html test/unit/*_test.rb test/unit/helpers/*_test.rb")
#    system("#{rcov} --no-html test/functional/*_test.rb")
#    system("#{rcov} --html test/integration/*_test.rb")
#    system("open coverage/index.html") if PLATFORM['darwin']
#  end
#end
