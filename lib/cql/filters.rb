module CQL

  class TagFilter
    attr_reader :tags

    def initialize tags
      @tags = tags
    end

    def has_tags?(object, target_tags)
      target_tags.all? { |target_tag|
        tags = object.tags
        tags = tags.collect { |tag| tag.name } unless Gem.loaded_specs['cuke_modeler'].version.version[/^0/]
        tags.include?(target_tag)
      }
    end

    def execute objects
      objects.find_all { |object| has_tags?(object, tags) }
    end

  end

  class ContentMatchFilter
    attr_reader :pattern

    def initialize(pattern)
      raise(ArgumentError, "Can only match a String or Regexp. Got #{pattern.class}.") unless pattern.is_a?(String) || pattern.is_a?(Regexp)

      @pattern = pattern
    end

    def content_match?(content)
      if pattern.is_a?(String)
        content.any? { |thing| thing == pattern }
      else
        content.any? { |thing| thing =~ pattern }
      end
    end

  end

  class TypeCountFilter
    attr_reader :types, :comparison

    def initialize types, comparison
      @types = types
      @comparison = comparison
    end

    def execute input
      input.find_all do |object|
        type_count(object).send(comparison.operator, comparison.amount)
      end
    end

  end

  class NameFilter < ContentMatchFilter

    def execute(input)
      input.find_all do |object|
        content_match?([object.name])
      end
    end

  end

  class TagCountFilter < TypeCountFilter

    def type_count(test)
      test.tags.size
    end

  end

end