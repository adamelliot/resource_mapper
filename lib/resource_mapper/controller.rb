module ResourceMapper
  module Controller
    def self.included(subclass)
      subclass.class_eval do
        include ResourceMapper::Helpers
        include ResourceMapper::Actions
        extend  ResourceMapper::Accessors
        extend  ResourceMapper::ClassMethods
      
        class_reader_writer :belongs_to, *NAME_ACCESSORS
        NAME_ACCESSORS.each { |accessor| send(accessor, controller_name.singularize.underscore) }

        ACTIONS.each do |action|
          class_scoping_reader action, FAILABLE_ACTIONS.include?(action) ? ResourceMapper::FailableActionOptions.new : ResourceMapper::ActionOptions.new
        end
      end

      init_default_actions(subclass)
    end

    private
      def self.init_default_actions(klass)
        klass.class_eval do
          index.wants.html

          show do
            wants.html
            failure.wants.html { "Member object not found." }
          end

          create do
            wants.html { redirect_to object_url }

            failure.wants.html { "new" }
          end

          update do
            wants.html { redirect_to object_url }

            failure.wants.html { "edit" }
          end

          destroy do
            wants.html #{ redirect_to collection_url }
            failure.wants.html #{ redirect_to object_url }
          end
          
          class << self
            def singleton?
              false
            end
          end
        end
      end
  end
end
