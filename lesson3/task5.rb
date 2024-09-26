# Days by months in not leap year
days_in_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

def leap_year?(year)
  result = false
  if year%4 == 0
    if year%100 == 0
      year%400 == 0 ? true : false
    else
      true
    end
  end
end

def after_febrary?(month)
  month > 2 ? true : false
end

print 'Enter day: '
day = gets.to_i
print 'Enter month: '
month = gets.to_i
print 'Enter year: '
year = gets.to_i

# In leap year on one day bigger in febrary
date_number = leap_year?(year) && after_febrary?(month) ? 1 : 0

# Add days in previus months and days in current month
date_number += days_in_months.slice(...month-1).sum + day
puts date_number
