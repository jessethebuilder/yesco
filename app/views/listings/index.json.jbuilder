json.array! @listings do |l|
  json.partial! 'listings/show', :listing => l
end
