module ResourceMapper
  module ClassMethods

    # Use this method in your controller to specify which actions you'd like it to respond to.
    #
    #   class PostsController < ResourceController::Base
    #     actions :all, :except => :create
    #   end
    def actions(*opts)
      config = {}
      config.merge!(opts.pop) if opts.last.is_a?(Hash)

      all_actions = (singleton? ? ResourceMapper::SINGLETON_ACTIONS : ResourceMapper::ACTIONS)

      actions_to_remove = []
      actions_to_remove += all_actions - opts unless opts.first == :all                
      actions_to_remove += [*config[:except]] if config[:except]
      actions_to_remove.uniq!

      actions_to_remove.each { |action| undef_method(action) if method_defined?(action) }
    end

    def key(sym)
      class_eval <<-"end_eval", __FILE__, __LINE__
        def key
          :#{sym}
        end
      end_eval
    end

    def before(*args, &block)
      raise "Need to specify a block for a before set." unless block_given?

      args.flatten.each do |arg|
        self.method(arg).call.before &block
      end
    end

    # TODO: After fail after success
    def after(*args, &block)
      raise "Need to specify a block for an after set." unless block_given?

      args.flatten.each do |arg|
        self.method(arg).call.after &block
      end
    end

    def read_params(*args)
      class_eval <<-"end_eval", __FILE__, __LINE__
        def read_params
          {:only => #{args}}
        end
      end_eval
    end

    def write_params(*args)
      class_eval <<-"end_eval", __FILE__, __LINE__
        def write_params
          #{args}
        end
      end_eval
    end
    
  end
end
