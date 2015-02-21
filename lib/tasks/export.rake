# encoding: UTF-8

require 'open-uri'
require 'uri'

namespace :json do
  desc "Export all json data by state to /tmp"
  task :export => [:environment] do

    encoding_options = {
      :invalid           => :replace,  # Replace invalid byte sequences
      :undef             => :replace,  # Replace anything not defined in ASCII
      :replace           => '',        # Use a blank for those replacements
      :universal_newline => true       # Always break lines with \n
    }
    # states = State.all.map(&:name).map{|s| s.encode(Encoding.find('ASCII'), encoding_options) }

    State.all.each do |state|
      # TODO: remove this hardcode stuff for localhost
      json_data = Curl.get(URI.escape("http://localhost:3000/departamento/#{state.name}.json"))
        .body_str
        .force_encoding('UTF-8')
      File.open(File.join(Rails.root, "tmp", "#{state.path}.json"), "w") do |f|
        f.write(json_data)
      end
    end
  end
end
