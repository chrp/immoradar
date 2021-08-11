ENVIRONMENT = ENV['RACK_ENV'] || ENV['ENV'] || 'development'

if ENVIRONMENT == 'development'
  puts 'Loading .env'
  require 'dotenv'
  Dotenv.load
end

require 'sinatra'

set :environment, ENVIRONMENT

require "sinatra/protection"
require 'sinatra/activerecord'
require 'rack/contrib/json_body_parser'
require 'ransack'
require 'haml'
require 'pry' if development?

# Load models
Dir.glob("./models/*.rb").sort.each { |file| require file }

# Parses JSON post bodies into params
use Rack::JSONBodyParser

# Basic auth
set :username, ENV['API_USERNAME']
set :password, ENV['API_PASSWORD']

class AppError < RuntimeError; end

configure do
  disable :raise_errors
  set :show_exceptions, :after_handler
end

get '/' do
  send_file File.expand_path('index.html', settings.public_dir)
end

namespace '/api' do
  before do
    content_type :json
    protected!
  end

  get '/ping' do
    { result: 'pong', errors: nil, successful: true }.to_json
  end

  get '/entries/:platform/:platform_key(.:format)?' do
    ad = Ad.find_by(platform: params[:platform], platform_key: params[:platform_key])

    if ad.nil?
      not_found
    elsif params[:format] == 'html'
      haml :ads, locals: { ad: ad }
    else
      ad.to_json
    end
  end

  post '/undo/ignore' do
    ad = Ad.where(is_ignored: 1).order(:updated_at).last
    ad.update(is_ignored: 0) if ad

    { affected_count: ad ? 1 : 0,
      successful: true,
      errors: nil }.to_json
  end

  get '/entries' do
    limit = Integer(params[:limit]) rescue 1000 # default 1000
    limit = [limit, 10000].min # max 10000
    collection = Ad.ransack(params[:q]).result.where.not(is_ignored: 1).order('id DESC')
    { unlimited_count: collection.count,
      applied_limit: limit,
      result: collection.limit(limit),
      successful: true,
      errors: nil }.to_json
  end

  put '/entries/ignore' do
    count = Ad.ransack(params[:q]).result.update_all(is_ignored: 1)
    { affected_count: count,
      successful: true,
      errors: nil }.to_json
  end

  post '/entries' do
    # We need a data key
    raise AppError.new('Missing data key')  unless params[:data].is_a? Array

    # Each entry in there needs minimal fields so that we can generate useful errors
    %i(platform platform_key url).each do |req_attr|
      if params['data'].any? { |e| e[req_attr].nil? }
        raise AppError.new("Missing #{req_attr.to_s}")
      end
    end

    result = params[:data].map do |e|
      ad = Ad.find_or_build_and_assign_attributes e.to_h.symbolize_keys
      updated = ad.id.present?
      error_message = ad.save ? false : ad.errors.to_a.join(', ')

      {
        successful: !error_message,
        updated: updated,
        errors: error_message,
        platform: e[:platform],
        platform_key: e[:platform_key],
        url: e[:url]
      }
    end

    status 200
    { result: result, successful: true, errors: nil }.to_json
  end

  put '/entries/:platform/:platform_key/:action' do
    ad = Ad.find_by(platform: params[:platform], platform_key: params[:platform_key])

    if ad.nil?
      not_found
      break
    end

    case params[:action]
    when 'ignore'
      ad.assign_attributes(is_ignored: 1)
    when 'mark'
      ad.assign_attributes(is_favorite: 1)
    when 'unmark'
      ad.assign_attributes(is_favorite: 0)
    end

    if ad.save
      { successful: true, errors: nil, result: ad.to_json }.to_json
    else
      status 400
      { successful: false, errors: ad.errors.to_a.join(', '), result: ad.to_json }.to_json
    end
  end

  error AppError do
    status 400
    {
      successful: false,
      result: nil,
      errors: env['sinatra.error'].message,
    }.to_json
  end

  error ActiveModel::UnknownAttributeError do
    status 400
    {
      successful: false,
      result: nil,
      errors: env['sinatra.error'].message,
    }.to_json
  end
end

not_found do
  redirect 'http://http.cat/404'
end
