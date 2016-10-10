class Stream < ActiveRecord::Base
  belongs_to :game

  def self.load_streams
    all_streams = request_streams
    console_streams = request_streams('xb1') + request_streams('ps4')
    pc_streams = all_streams.reject { |stream| console_streams.include? stream[:name] }
    pc_streams.each do |stream|
      Stream.create(
        name: stream[:name],
        url: stream[:url],
        title: stream[:title],
        game: Game.find_or_create_by(name: stream[:game]),
        preview: stream[:preview],
        viewers: stream[:viewers]
      )
    end
  end

  private
  def self.request_streams(platform = nil)
    streams = []
    offset = 0
    conn = Faraday.new(:url => 'https://api.twitch.tv') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    begin
      response = conn.get do |req|
        req.url '/kraken/streams',
          limit: 100,
          game: 'Rocket League',
          offset: offset
        req.headers['Client-ID'] = ENV['CLIENT_ID']
        if platform == 'xb1'
          req.params['xbox_heartbeat'] = true
        elsif platform == 'ps4'
          req.params['sce_platform'] = 'ps4'
        end
      end
      response_hash = JSON.parse(response.body)
      response_hash['streams'].each do |stream|
        if platform
          streams << stream['channel']['display_name']
        else
          streams << {
            name: stream['channel']['display_name'],
            url: stream['channel']['url'],
            title: stream['channel']['status'],
            game: stream['channel']['game'],
            preview: stream['preview']['medium'],
            viewers: stream['viewers']
          }
        end
      end
      offset += 100
    end until response_hash['streams'].count == 0 || response_hash['streams'].count < 100
    streams
  end
end
