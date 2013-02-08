namespace :ssh do

	desc "do all the test"
	task :all do
		sh 'bundle exec rspec spec'
	end

	desc "regenerating test report"
	task :report do		
		begin
			sh 'bundle exec rspec spec -f h -o report.html'			
		rescue 
			puts "failed"
		end
		sh 'rm public/report.html'
		sh 'mv report.html public/report.html'
	end
end
