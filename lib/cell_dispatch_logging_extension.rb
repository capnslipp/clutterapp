# Adds nice colored logging to Cell::Base when a state is rendered.
# Requires logger_prefix_extension.

module Cell
  class Base
    
    # Log and call the state method.
    def dispatch_state(state)
      log_info(state)
      send(state)
    end
    
    
  protected
    
    def log_info(state_name)
      logger.prefixed 'Cell Dispatch', :light_yellow, "#{self.class} #{state_name}"
      logger.debug ActiveSupport::BufferedLogger::PREFIX_SPACE * 2 + "Options: #{@opts.inspect}}"
    end
    
  end
end