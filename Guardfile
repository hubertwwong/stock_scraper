# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# basic ruby file from code tuts.
# http://code.tutsplus.com/tutorials/testing-your-ruby-code-with-guard-rspec-pry--cms-19974
#guard 'rspec' do
  # watch /src/ files
  #watch(%r{^src/(.+).rb$}) do |m|
  #  "spec/features/#{m[1]}_spec.rb"
  #end

  # watch /spec/ files
  #watch(%r{^spec/(.+).rb$}) do |m|
  #  "spec/features/#{m[1]}.rb"
  #end
#end

#guard :rspec do
#  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
#end

# on guard_rspec file.
# https://github.com/guard/guard-rspec
#
guard :rspec do
  watch(%r{^spec/features/.+_spec\.rb$})
  watch(%r{^src/(.+)\.rb$})     { |m| "spec/features/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
