json.array!(@streams) do |stream|
  json.extract! stream, :id, :name, :url, :title, :preview, :viewers, :game_id
  json.url stream_url(stream, format: :json)
end
