module GQL
  class MapReduce

    def self.overview input
      input.map { |a| a['name'] }
    end

    def self.uri input
      input.map { |a| a['uri'] }
    end

    def self.find_feature input, args
      input.find { |feature| feature['name'] == args['feature'] }
    end

    def self.filter_features_by_tag input, args
      input.find_all { |feature| has_tags feature['tags'], args['tags'].flatten }
    end

    def self.scenario_by_feature_and_tag input, feature_to_find, condition, *tags_to_find
      scenarios = []
      input.each do |feature|
        if feature['name'] == feature_to_find
          feature['elements'].each do |element|
            if element['type'] == "scenario" and has_tags(element['tags'], tags_to_find) == condition
              scenarios.push element['name']
            end
          end
        end
      end
      scenarios
    end

    def self.scenario input, args
      input = find_feature input, 'feature'=>args['feature']
      input['elements'].find{|element|element['name'] == args['child_name'] }
    end

    def self.find input, args
      results = []
      input = [find_feature(input, 'feature'=>args['feature'])] if args.has_key?('feature')
      input.each do |feature|
        feature['elements'].each do |element|
          results.push element['name'] if element['type'] == args['what']
        end
      end
      results
    end

    def self.tags input
      tags = Set.new
      input.each do |feature|
        feature['elements'].each do |element|
          break if element['tags'] == nil
          element['tags'].each { |tag| tags.add tag['name'] }
        end
      end
      tags.to_a
    end

    def self.has_tags given, search
      return false if given == nil
      search.count { |tag_for_search| given.map { |t| t["name"] }.include?(tag_for_search) }==search.size
    end

  end
end