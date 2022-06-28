# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "visible_scratch_skillz"
set :repo_url, "git@github.com:obregonia1/visible_scratch_skillz"

set :branch, 'main'
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/rails/visible_scratch_skillz"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/master.key"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "node_modules"
append :linked_dirs, '.bundle'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# set :rbenv_type, :system
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
# set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :log_level, :debug

set :rbenv_path, '/home/obregonia1/.rbenv'
set :bundle_path, -> { shared_path.join('vendor/bundle') }

set :nginx_config_name, "vss.conf"
set :nginx_sites_enabled_path, "/etc/nginx/conf.d"

desc 'Build JavaScript for production'
task :yarn_production do
  on roles(:app) do
    within release_path do
      execute :yarn, 'build'
    end
  end
end

after 'deploy:updated', 'yarn_production'
