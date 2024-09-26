cart = {}

loop do
  print 'Product name or stop: '
  product = gets.chomp
  break if product == 'stop'

  unless product == "" 
    print 'Price: '
    price = gets.to_f
    print 'Amount: '
    amount = gets.to_f
    cart[product.to_sym] = { price: price, amount: amount }
  else
    puts 'Empty product name, please try again...'
    next
  end
end

puts
puts '*' * 80
puts cart

# Output position cost
puts '*' * 80
total = 0
cart.each do |key, value|
  position_cost = value[:amount] * value[:price]
  total += position_cost
  puts "#{key}: #{value[:amount]} x #{value[:price]} = #{position_cost}"
end

puts '*' * 80
puts "Total: #{total}"