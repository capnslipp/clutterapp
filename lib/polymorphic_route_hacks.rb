# This fix allows polymophic_urls and polymorphic_paths to work with fully-symbol-ed arrays of 2 or more pieces like they do with a single symbol piece.
# 
# Semi-fictional example:
#   <% unless current_user.admin? %>
#     <%= link_to "My Account", [current_user] %><%# works: generates "/users/1" %>
#     <%= link_to "Logout", [:user_session], :method => :delete %><%# works: generates "/user_session" %>
#   <% else %>
#     <%= link_to "My Account", [:admin, current_user] %><%# works: generates "/admin/users/1" %>
#     <%= link_to "Logout", [:admin, :user_session], :method => :delete %><%# breaks without this enhancement: "undefined method `admin_user_session_nil_class_path'" %>
#   <% end %>


module ActionController
  module PolymorphicRoutes
      def extract_namespace(record_or_hash_or_array)
        return "" unless record_or_hash_or_array.is_a?(Array)
        
        namespace_keys = []
        # change from Rails 2.3.4: this line has "&& record_or_hash_or_array.size > 1" added
        while (key = record_or_hash_or_array.first) && (key.is_a?(String) || key.is_a?(Symbol)) && record_or_hash_or_array.size > 1
          namespace_keys << record_or_hash_or_array.shift
        end
        
        namespace_keys.map {|k| "#{k}_"}.join
      end
  end
end
