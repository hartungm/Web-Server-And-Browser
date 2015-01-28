puts "Ruby Test File!"
params = ARGV[0]
hash = Hash.new
params.split("&").each do |a|
	b = a.split("=")
	hash[b[0]] = b[1]
end
puts hash
puts hash["arg1"].to_i + hash["arg2"].to_i