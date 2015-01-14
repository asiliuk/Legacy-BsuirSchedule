File.open('./res.txt', 'w') do |res|
Dir[ File.join('./', '**', 'BS*.m') ].reject do |p| 
  if !File.directory? p 
    f = File.open(p, 'rb')
    res.write(f.read)
  end
end
end