require 'sinatra'
require 'slim'
require 'config_env'
require 'rack-ssl-enforcer'
require 'json'
require_relative 'model/coach'

configure :development, :test do
  ConfigEnv.path_to_config("#{__dir__}/config/config_env.rb")
end

configure :production do
  require 'newrelic_rpm'
end

# App for Coach Star Calculator
class FmCoachCalc < Sinatra::Base
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
end
