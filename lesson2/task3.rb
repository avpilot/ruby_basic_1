# Задача 3. Прямоугольный треугольник

def triangle_exist?(a,b,c)
  if a <= 0 || b <= 0 || c <= 0
    false
  elsif a + b <= c || a + c <= b || b + c <= a
    false
  else
    true
  end
end

puts 'Введите стороны треугольника:'
print 'a = '
a = gets.to_f
print 'b = '
b = gets.to_f
print 'c = '
c = gets.to_f

if triangle_exist?(a, b, c)
  puts 'Треугольник существует'

  # Найдём гипотенузу и катеты
  if a > b && a > c
    hypotenuse, leg_1, leg_2 = a, b, c
  elsif b > a && b > c
    hypotenuse, leg_1, leg_2 = b, a, c
  else
    hypotenuse, leg_1, leg_2 = c, a, b
  end
  
  if a == b && b == c
    puts 'Треугольник равносторонний'
  else
    puts 'Треугольник прямоугольный' if hypotenuse ** 2 == leg_1 ** 2 + leg_2 ** 2
    puts 'Треугольник равнобедренный' if a == b || a == c || b == c
  end

else
  puts 'Треугольник не существует'
end