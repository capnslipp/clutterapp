module Carpesium
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    # generates/runs (given an associaion_name of :root_pile) this code:
    # 
    #   ROOT_PILE_ASSOCIATION_REFLECTION = reflect_on_association(:root_pile)
    #   
    #   def autosave_associated_records_for_root_pile
    #     @already_saved_associated_records_for ||= {}
    #     
    #     return if @already_saved_associated_records_for[:root_pile]
    #     
    #     @already_saved_associated_records_for[:root_pile] = true
    #     save_belongs_to_association(ROOT_PILE_ASSOCIATION_REFLECTION)
    #   end
    #   
    #   def reset_autosave_associated_records_for_root_pile
    #     @already_saved_associated_records_for[:root_pile] = false
    #   end
    #   
    #   after_save :reset_autosave_associated_records_for_root_pile
    # 
    def carpesium(association_name)
      association_name = association_name.to_sym
      association_reflection_const_name = "#{association_name.to_s.upcase}_ASSOCIATION_REFLECTION"
      autosave_method_name = :"autosave_associated_records_for_#{association_name.to_s}"
      reset_method_name = :"reset_autosave_associated_records_for_#{association_name.to_s}"
      
      begin # generate/run class-level code
        self.const_set(association_reflection_const_name, reflect_on_association(association_name))
        
        define_method(autosave_method_name) do
          @already_saved_associated_records_for ||= {}
          
          return if @already_saved_associated_records_for[association_name]
          
          @already_saved_associated_records_for[association_name] = true
          save_belongs_to_association( self.class.const_get(association_reflection_const_name) )
        end
        
        define_method(reset_method_name) do
          @already_saved_associated_records_for[association_name] = false
        end
        
        after_save reset_method_name
      end
    end
    
  end
  
end
