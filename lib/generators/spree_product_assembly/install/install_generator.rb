module SpreeProductGroups
  module Generators
    class InstallGenerator < Rails::Generators::Base

      def add_javascripts
        append_file "app/assets/javascripts/spree/frontend/all.js", "//= require spree/frontend/spree_product_groups\n"
        append_file "app/assets/javascripts/spree/backend/all.js", "//= require spree/backend/spree_product_groups\n"
      end

      def add_stylesheets
        inject_into_file "app/assets/stylesheets/spree/frontend/all.css", " *= require spree/frontend/spree_product_groups\n", :before => /\*\//, :verbose => true
        inject_into_file "app/assets/stylesheets/spree/backend/all.css", " *= require spree/backend/spree_product_groups\n", :before => /\*\//, :verbose => true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_product_groups'
      end

      def run_migrations
         res = ask "Would you like to run the migrations now? [Y/n]"
         if res == "" || res.downcase == "y"
           run 'bundle exec rake db:migrate'
         else
           puts "Skiping rake db:migrate, don't forget to run it!"
         end
      end
    end
  end
end

