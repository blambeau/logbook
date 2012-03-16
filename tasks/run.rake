task :run do
  system("bundle exec ruby -Ilib -rlogbook -e 'Logbook::Backend.run!'")
end