class Stemmer
  def initialize(directories_path, language)
    FFI::Hunspell.directories = [directories_path] + FFI::Hunspell.directories
    @dict = FFI::Hunspell.dict(language)
  end

  def call(expression)
    expression.split(' ').map do |token|
      stemmed = @dict.stem(token)
      stemmed.empty? ? token : stemmed.min_by(&:size)
    end.join(' ')
  end
end