task :"test:frontend" do
  system("export NODE_PATH=./src && jasmine-node --color --matchall --coffee spec/client/")
end
task :test => :"test:frontend"