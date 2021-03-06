Given 'the config file:' do |body|
  CommandLineHelpers.set_config_file body
end

Given 'the mustache:' do |body|
  CommandLineHelpers.set_mustache_file body
end

When "I ride the mustache with '$args'" do |args|
  @last_invocation = CommandLineHelpers.invoke_mustache_file_with args
end

Then 'I see:' do |output|
  @last_invocation.stdout.should include strip_leading(output)
end

Then /^(stdout|stderr) is empty$/ do |stream_name|
  @last_invocation.send(stream_name).should == ''
end

Then 'the exit status is $status' do |status|
  @last_invocation.exitstatus.to_s.should == status
end
