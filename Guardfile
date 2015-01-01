# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec, cmd: 'bundle exec rspec' do
  # watch(%r{^spec/.+_spec\.rb$})      { "spec" }
  watch(%r{^spec/.+_spec\.rb$})      { |m| m[0] }
  # watch(%r{^lib/(.+)\.rb$})          { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})          { |m| "spec" }
  watch('spec/spec_helper.rb')       { "spec" }
  watch(%r{^spec/support/(.+)\.rb$}) { "spec" }
end
