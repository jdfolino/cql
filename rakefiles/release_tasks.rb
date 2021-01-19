namespace 'cql' do

  desc 'Check that things look good before trying to release'
  task :prerelease_check do
    begin
      Rake::Task['cql:test_everything'].invoke
      Rake::Task['cql:check_documentation'].invoke
      Rake::Task['cql:rubocop'].invoke
    rescue => e # rubocop:disable Lint/RescueWithoutErrorClass
      puts Rainbow("Something isn't right!").red
      raise e
    end

    puts Rainbow('All is well. :)').green
  end

end
