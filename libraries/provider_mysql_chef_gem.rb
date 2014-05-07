class Chef
  class Provider
    class MysqlChefGem < Chef::Provider::LWRPBase

      # Monkey patch to not install libmysqlclient-dev since we install ours
      def action_install
        converge_by 'install mysql chef_gem and dependencies' do
          recipe_eval do
            run_context.include_recipe 'build-essential::default'
          end

          chef_gem 'mysql' do
            action :install
          end
        end
      end

    end
  end
end
