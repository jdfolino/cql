module GQL
  module Dsl

    def names
      'names'
    end

    def features
      'features'
    end

    def scenario_outlines
      'scenario_outlines'
    end

    def file_names
      'uri'
    end

    def scenarios
      'scenarios'
    end

    def select what
      @what = what
    end

    def from where
      @from = where
      @data
    end

    def tag tag
      {'tag'=>tag}
    end

    def tags *tags
      {'tags'=>tags}
    end

    def with filter
      if filter.has_key? 'tag'
        @data = GQL::MapReduce.filter_features_by_tag(@data, 'tags'=>[filter['tag']])
      elsif filter.has_key? 'tags'
        @data = GQL::MapReduce.filter_features_by_tag(@data, 'tags'=>filter['tags'])
      end
      @data
    end

    class Query
      include Dsl
      attr_reader :data, :what

      def initialize features, &block
        @data = features
        @data = self.instance_eval(&block)
        results_map = {"uri-features" => GQL::MapReduce.uri(@data),
                       "names-features" => GQL::MapReduce.overview(@data),
                       "names-scenario_outlines" => GQL::MapReduce.find(@data, 'what'=>'scenario_outline'),
                       "names-scenarios" => GQL::MapReduce.find(@data, 'what'=>'scenario')}
        @data = results_map[@what + "-" + @from]
      end
    end

  end

end