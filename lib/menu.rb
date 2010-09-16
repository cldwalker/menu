module Menu
  extend self

  def run(lines=ARGV)
    lines = $stdin.read.split("\n") if !$stdin.tty?
    prompt(lines)
    answer = ask
    puts parse_answer(lines, answer)
  end

  def prompt(lines)
    lines.each_with_index {|obj,i|
      puts "#{i+1}. #{obj}"
    }
    print "Choose: "
  end

  def ask
    $stdin.reopen '/dev/tty'
    $stdin.gets.chomp
  end

  def parse_answer(array, input, options={})
    return array if input.strip == '*'
    result = []
    input.split(/\s*,\s*/).each do |e|
      if e.include?('-')
        min,max = e.split('-')
        slice_min = min.to_i - 1
        result.push(*array.slice(slice_min, max.to_i - min.to_i + 1))
      elsif e =~ /\s*(\d+)\s*/
        index = $1.to_i - 1
        next if index < 0
        result.push(array[index]) if array[index]
      else
        abort("`#{e}' is an invalid choice.")
      end
    end
    result
  end
end
