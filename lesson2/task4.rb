# Задача 4. Квадратное уравнение

puts 'Введите коэффициенты квадратного уравнения:'
print 'a = '
a = gets.to_f
print 'b = '
b = gets.to_f
print 'c = '
c = gets.to_f

d = b ** 2 - 4 * a * c
puts "D = #{d}"

if a == 0
  puts 'Уравнение не квадратное, коэффициент "a" должены быть отлиен от 0'
elsif d == 0
  puts "x1 = x2 = #{-b / (2.0 * a)}"
elsif d > 0
  puts "x1 = #{(-b + Math.sqrt(d))/ (2.0 * a)}"
  puts "x2 = #{(-b - Math.sqrt(d))/ (2.0 * a)}"
else
  puts "Корней нет" 
end