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
        not_found             = lambda { throw(:halt, [404, 'Not found.']) }
        unprocessable_entity  = lambda { throw(:halt, [422, 'Unprocessable entity.']) }
        
        klass.class_eval do
          index do
#            wants.xml { collection.to_xml }
            wants.json { collection.to_json(:only => index_attrs) }
#            wants.yaml { collection.to_yaml }
#            wants.plist { collection.to_plist }
          end

          show do
#            wants.xml { object.to_xml }
            wants.json { object.to_json(:only => show_attrs) }
#            wants.yaml { object.to_yaml }
#            wants.plist { object.to_plist }
            
            failure.wants.html &not_found
#            failure.wants.xml &not_found
            failure.wants.json &not_found
#            failure.wants.yaml &not_found
#            failure.wants.plist &not_found
          end

          create do
            wants.html { object.to_json(:only => show_attrs) }
#            wants.xml { object.to_xml }
            wants.json { object.to_json(:only => show_attrs) }
#            wants.yaml { object.to_xml }
#            wants.plist { object.to_json }

            failure.wants.html &unprocessable_entity
#            failure.wants.xml &unprocessable_entity
            failure.wants.json &unprocessable_entity
#            failure.wants.yaml &unprocessable_entity
#            failure.wants.plist &unprocessable_entity
          end

          update do
            wants.html { object.to_json(:only => show_attrs) }
#            wants.xml { object.to_xml }
            wants.json { object.to_json(:only => show_attrs) }
#            wants.yaml { object.to_xml }
#            wants.plist { object.to_json }

            failure.wants.html &unprocessable_entity
#            failure.wants.xml &unprocessable_entity
            failure.wants.json &unprocessable_entity
#            failure.wants.yaml &unprocessable_entity
#            failure.wants.plist &unprocessable_entity
          end

          destroy do
            wants.html { "" }
#            wants.xml { "" }
            wants.json { "" }
#            wants.yaml { "" }
#            wants.plist { "" }

            failure.wants.html &unprocessable_entity
#            failure.wants.xml &unprocessable_entity
            failure.wants.json &unprocessable_entity
#            failure.wants.yaml &unprocessable_entity
#            failure.wants.plist &unprocessable_entity
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
