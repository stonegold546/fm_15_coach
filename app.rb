require 'sinatra'
require 'slim'
require 'config_env'
require 'rack-ssl-enforcer'
require 'json'
require 'slim/include'
require 'nokogiri'
require_relative 'model/coach'

configure :development, :test do
  ConfigEnv.path_to_config("#{__dir__}/config/config_env.rb")
end

configure :production do
  require 'newrelic_rpm'
end

# App for Coach Star Calculator
class FmCoachCalc < Sinatra::Base
  enable :logging

  configure :production do
    use Rack::SslEnforcer
    set :session_secret, ENV['SYM_KEY']
  end

  get '/' do
    if params['discipline']
      coach = Coach.new(params['discipline'].to_i, params['determination'].to_i,
                        params['motivating'].to_i)
      strength = coach.strength(params['fitness'] ? params['fitness'].to_i : 0)
      tactics = coach.strength(params['tactical'] ? params['tactical'].to_i : 0)
      shot_stopping = coach.goalkeeping(
        params['goalkeepers'] ? params['goalkeepers'].to_i : 0,
        params['tactical'] ? params['tactical'].to_i : 0
      )
      handling = coach.goalkeeping(
        params['goalkeepers'] ? params['goalkeepers'].to_i : 0,
        params['technical'] ? params['technical'].to_i : 0
      )
      defending = coach.defending(
        params['defending'] ? params['defending'].to_i : 0,
        params['tactical'] ? params['tactical'].to_i : 0
      )
      ball_control = coach.ball_control(
        params['technical'] ? params['technical'].to_i : 0,
        params['mental'] ? params['mental'].to_i : 0
      )
      attacking = coach.attacking(
        params['attacking'] ? params['attacking'].to_i : 0,
        params['tactical'] ? params['tactical'].to_i : 0
      )
      shooting = coach.shooting(
        params['technical'] ? params['technical'].to_i : 0,
        params['attacking'] ? params['attacking'].to_i : 0
      )
      slim :index, locals: { result: { 'Strength' => strength,
                                       'Aerobics' => strength,
                                       'Shot Stopping' => shot_stopping,
                                       'Handling' => handling,
                                       'Tactics' => tactics,
                                       'Ball Control' => ball_control,
                                       'Defending' => defending,
                                       'Attacking' => attacking,
                                       'Shooting' => shooting
                                       },
                             val: params.to_json }
    else
      slim :index, locals: { result: nil, val: nil }
    end
  end

  get '/multi/?' do
    slim :multi
  end

  post '/multi/?' do
    begin
      doc = Nokogiri::HTML(params['coach_file'][:tempfile])
      data = doc.css('tr').map do |row|
        row.css('td').map(&:text)
      end
      data.delete([])
      result = [[]]
      data.each_with_index do |x, idx|
        coach = Coach.new(x[9].to_i, x[8].to_i, x[10].to_i)
        result[idx] = [x[0]]
        result[idx].push(coach.strength(x[3].to_i),
                         coach.strength(x[3].to_i),
                         coach.goalkeeping(x[4].to_i, x[6].to_i),
                         coach.goalkeeping(x[4].to_i, x[7].to_i),
                         coach.tactics(x[6].to_i),
                         coach.ball_control(x[7].to_i, x[5].to_i),
                         coach.defending(x[2].to_i, x[6].to_i),
                         coach.attacking(x[1].to_i, x[6].to_i),
                         coach.shooting(x[7].to_i, x[1].to_i))
        result[idx][10..-1] = x[1..-1]
        logger.info "RESULT: #{result[idx].length}"
      end
      slim :multi_result, locals: { result: result }
    rescue => e
      logger.error e
    end
  end
end
