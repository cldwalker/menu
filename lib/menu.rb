module Menu
  extend self

  def run(lines=ARGV)
    lines = !$stdin.tty?  ? $stdin.read : ARGV.join(' ')
    lines = lines.split("\n")
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
    options = {:splitter=>","}.merge(options)
    return array if input.strip == '*'
    result = []
    input.split(options[:splitter]).each do |e|
      if e =~ /-|\.\./
        min,max = e.split(/-|\.\./)
        slice_min = min.to_i - 1
        result.push(*array.slice(slice_min, max.to_i - min.to_i + 1))
      elsif e =~ /\s*(\d+)\s*/
        index = $1.to_i - 1
        next if index < 0
        result.push(array[index]) if array[index]
      end
    end
    result
  end

  def parse_answer2(lines, answer)
    if !answer[/^\d+$/] || answer.to_i < 1 || answer.to_i > lines.size
      abort("`#{answer}' is an invalid choice.")
    end
    lines[answer.to_i - 1]
  end
end
