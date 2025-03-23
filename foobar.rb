def foobar(n)
    (1..n).each do |i|
        result = ''
        result += 'foo' if i % 3 == 0
        result += 'bar' if i % 5 == 0
        puts result.empty? ? i.to_s : result
    end
end
