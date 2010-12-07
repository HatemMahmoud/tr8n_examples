load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'

namespace :deploy do

  task :start, :roles => :app do

  end

  task :restart, :roles => :app do
     run "rm #{current_path}/config/environment.rb; cp #{current_path}/config/environment_#{application}.rb #{current_path}/config/environment.rb;"
  end

end
