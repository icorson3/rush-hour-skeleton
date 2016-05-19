module ClientParser

  def parse_client_data(raw_params)
    a = raw_params.split("&").map { |string| string.split("=")}
    b = a.map do |string|
      {string[0].to_sym => string[1]}
    end
    b[0].merge(b[1])
    require "pry"; binding.pry
  end


end
