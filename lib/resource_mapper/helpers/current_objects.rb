module ResourceMapper
  module Helpers
    module CurrentObjects
      protected
        # Used internally to return the model for your resource.  
        #
        def model
          model_name.to_s.camelize.constantize
        end

  
        # Used to fetch the collection for the index method
        #
        # In order to customize the way the collection is fetched, to add something like pagination, for example, override this method.
        #
        def collection
          end_of_association_chain.all
        end
    
        # Returns the current param for key.
        # 
        # Override this method if you'd like to use an alternate param name.
        #
        def param
          params[:id]
        end
        
        # Returns the key used for finding.
        def key
          :id
        end
  
        # Used to fetch the current member object in all of the singular methods that operate on an existing member.
        #
        # Override this method if you'd like to fetch your objects in some alternate way, like using a permalink.
        #
        # class PostsController < ResourceController::Base
        #   private
        #     def object
        #       @object ||= end_of_association_chain.find_by_permalink(param)
        #     end
        #   end
        #
        def object
          @object ||= end_of_association_chain.first({key => param}) unless param.nil?
          @object
        end
    
        # Used internally to load the member object in to an instance variable @#{model_name} (i.e. @post)
        #
        def load_object
          instance_variable_set "@#{parent_type}", parent_object if parent?
          instance_variable_set "@#{object_name}", object
        end
    
        # Used internally to load the collection in to an instance variable @#{model_name.pluralize} (i.e. @posts)
        #
        def load_collection
          instance_variable_set "@#{parent_type}", parent_object if parent?
          instance_variable_set "@#{object_name.to_s.pluralize}", collection
        end
  
        # Returns the form params.  Defaults to params[model_name] (i.e. params["post"])
        #
        def object_params
          ret = params["#{object_name}"]
          ret.delete_if { |k, v| write_params.index(k.to_sym).nil? } unless write_params.nil?
          ret
        end
    
        # Builds the object, but doesn't save it, during the new, and create action.
        #
        def build_object
          @object = end_of_association_chain.send parent? ? :build : :new, object_params
        end

        def read_params ; nil end
        def write_params ; nil end
        
    end
  end
end
