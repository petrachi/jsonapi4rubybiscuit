Dir[Rails.root.join("lib/ext", "**", "*.rb")].map do |file|
  require file
end
