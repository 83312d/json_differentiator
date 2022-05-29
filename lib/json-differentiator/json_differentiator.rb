module JsonDifferentiator
  module_function

  def compare_json(initial_json, check_json)
    diff = {}

    # loop through each subarray || hash
    if initial_json.is_a? Array
      # lengths
      unless initial_json.length == check_json.length
        diff = diff.merge length: "Init json length is: #{initial_json.keys.length} and checked json length is: #{check_json.keys.length}"
      end
      initial_json.each_with_index do |obj, index|
        init_obj, check_obj = obj, check_json[index]
        compare_json init_obj, check_obj
      end

    elsif initial_json.is_a? Hash
      unless initial_json.keys.length == check_json.keys.length
        diff = diff.merge keys_length: "Init json length is: #{initial_json.keys.length} and checked json length is: #{check_json.keys.length}"
      end

      [initial_json, check_json].each { |json| json.delete_if {|key,value| %w[created_at updated_at].include? key} }

      initial_json.each do |key, value|
        unless check_json.has_key? key
          diff = diff.merge "#{key}": 'is missing'
          return diff
        end

        # TODO add value || type comparison
        # init_val, check_val = value, check_json[key]
        # compare_json init_val, check_val
      end
    end

    diff
  end
end