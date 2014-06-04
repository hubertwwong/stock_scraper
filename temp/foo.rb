module Foo

  def hello
    cups = ENV["COFFEE_CUPS"]
    puts "Made #{cups} cups of coffee. Shakes are gone."
  end

end
