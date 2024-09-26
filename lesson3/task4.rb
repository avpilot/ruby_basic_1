vovels = {}
vovel_letters = %w(а е ё и о у э ы ю я)

('а'..'я').each_with_index do |letter, i|
  vovels[letter.to_sym] = i + 1 if vovel_letters.include? letter 
end

puts vovels
