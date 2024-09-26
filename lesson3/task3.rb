# First two Fibonacci numbers
fib_numbers = [0, 1]

loop do
  next_fib = fib_numbers[-2..-1].sum
  break if next_fib > 100
  fib_numbers << next_fib
end

puts fib_numbers
