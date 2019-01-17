class String
  def convert_as_parameter
    downcase.parameterize.underscore
  end
end
