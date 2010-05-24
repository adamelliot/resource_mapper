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
          index.wants.json { collection.to_json }
          
          show do
            wants.json { object.to_json }
            failure.wants.json { "BOOOM!!!" }
          end

          create do
            wants.json { object.to_json }
            failure.wants.json { "BOOOM!!!" }
          end

          update do
            wants.html { object.to_json }
            failure.wants.json { "BOOOM!!!" }
          end

          destroy do
            wants.json
            failure.wants.json { "BOOM!!!" }
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
